#!/bin/sh

CHAIN_ID=${CHAIN_ID:-dymn-devnet}
MONIKER=${MONIKER:-dymn-devnet-validator}
KEY_NAME=${MONIKER:-dymn-devnet-key}
TOKEN_AMOUNT=${TOKEN_AMOUNT:-10000000000000000000000000uwasm}
STAKING_AMOUNT=${STAKING_AMOUNT:-1000000000uwasm}
DA_BASE_URL=${DA_BASE_URL:-'http://0.0.0.0:26658'}

rm -rf "$HOME"/.wasmd

wasmd tendermint unsafe-reset-all
wasmd init "$MONIKER" --chain-id "$CHAIN_ID"

sed -i'' -e 's/^minimum-gas-prices *= .*/minimum-gas-prices = "0uwasm"/' "$HOME"/.wasmd/config/app.toml
sed -i'' -e "s/^chain-id *= .*/chain-id = \"$CHAIN_ID\"/" "$HOME"/.wasmd/config/client.toml
sed -i'' -e '/\[rpc\]/,+3 s/laddr *= .*/laddr = "tcp:\/\/0.0.0.0:26657"/' "$HOME"/.wasmd/config/config.toml
sed -i'' -e 's/"time_iota_ms": "1000"/"time_iota_ms": "10"/' "$HOME"/.wasmd/config/genesis.json

wasmd keys add "$KEY_NAME" --keyring-backend test
wasmd add-genesis-account "$KEY_NAME" "$TOKEN_AMOUNT" --keyring-backend test
wasmd gentx "$KEY_NAME" "$STAKING_AMOUNT" --chain-id "$CHAIN_ID" --keyring-backend test

wasmd start --optimint.aggregator true \
  --optimint.da_layer celestia \
  --optimint.da_config "{\"base_url\":\"$DA_BASE_URL\",\"timeout\":60000000000,\"gas_limit\":6000000,\"namespace_id\":[0,0,0,0,0,0,255,255]}" \
  --optimint.namespace_id 000000000000FFFF \
  --optimint.da_start_height 21380 \
  --optimint.block_time 30s \
  --optimint.da_block_time 30s
