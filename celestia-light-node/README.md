# Celestia Light Node
Build and run celestia light client
```sh
# inside the project folder:
docker build -t celestia-light-node celestia-light-node/.
docker run -d --rm -p 26658:26658 -p 9090:9090 --name celestia-light-node celestia-light-node
```
Get the light node wallet address and fund it
```sh
docker exec celestia-light-node /bin/sh -c "cel-key show dymension-test --keyring-backend test --node.type light"
```
Get the address of the light node account, and request funding by going to celestia's discord 'faucet' channel and pasting: ```$request <wallet-address>```
