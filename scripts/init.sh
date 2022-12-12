#!/bin/sh

CHAIN_ID=${CHAIN_ID:-dymn-devnet}
MONIKER=${MONIKER:-dymn-devnet-validator}
KEY_NAME=${KEY_NAME:-dymn-devnet-key}
NAMESPACE_ID=${NAMESPACE_ID:-000000000000FFFF}
TOKEN_AMOUNT=${TOKEN_AMOUNT:-10000000000000000000000000uwasm}
STAKING_AMOUNT=${STAKING_AMOUNT:-1000000000uwasm}

ROLLAPP_ID="local-rollapp"
SETTLEMENT_RPC="0.0.0.0:36657"
SETTLEMENT_CONFIG="{\"node_address\": \"http:\/\/$SETTLEMENT_RPC\", \"rollapp_id\": \"$ROLLAPP_ID\", \"dym_account_name\": \"$KEY_NAME\", \"keyring_home_dir\": \"$HOME/.dymension/\", \"keyring_backend\":\"test\"}"
NAMESPACE_ID=000000000000FFFF
CELESTIA_LIGHT_CLIENT_ENDPOINT="127.0.0.1:26659"
DA_CONFIG="{\"base_url\": \"http:\/\/$CELESTIA_LIGHT_CLIENT_ENDPOINT\", \"timeout\": 60000000000, \"gas_limit\": 6000000, \"namespace_id\": [0,0,0,0,0,0,255,255]}"

rm -rf "$HOME"/.wasmd

wasmd tendermint unsafe-reset-all
wasmd init "$MONIKER" --chain-id "$CHAIN_ID"

sed -i'' -e 's/^minimum-gas-prices *= .*/minimum-gas-prices = "0uwasm"/' "$HOME"/.wasmd/config/app.toml
sed -i'' -e '/\[api\]/,+3 s/enable *= .*/enable = true/' "$HOME"/.wasmd/config/app.toml
sed -i'' -e "s/^chain-id *= .*/chain-id = \"$CHAIN_ID\"/" "$HOME"/.wasmd/config/client.toml
sed -i'' -e '/\[rpc\]/,+3 s/laddr *= .*/laddr = "tcp:\/\/0.0.0.0:26657"/' "$HOME"/.wasmd/config/config.toml
sed -i'' -e 's/"time_iota_ms": "1000"/"time_iota_ms": "10"/' "$HOME"/.wasmd/config/genesis.json
sed -i'' -e 's/bond_denom": ".*"/bond_denom": "uwasm"/' "$HOME"/.wasmd/config/genesis.json
sed -i'' -e 's/mint_denom": ".*"/mint_denom": "uwasm"/' "$HOME"/.wasmd/config/genesis.json

wasmd keys add "$KEY_NAME"
wasmd add-genesis-account "$KEY_NAME" "$TOKEN_AMOUNT"
wasmd gentx "$KEY_NAME" "$STAKING_AMOUNT" --chain-id "$CHAIN_ID"
wasmd collect-gentxs

wasmd start --dymint.aggregator true \
  --dymint.settlement_layer dymension \
  --dymint.settlement_config "$SETTLEMENT_CONFIG" \
  --dymint.block_batch_size 500 \
  --dymint.namespace_id "$NAMESPACE_ID" \
  --dymint.da_layer "celestia" \
  --dymint.da_config="$DA_CONFIG" \
  --dymint.block_time 0.2s