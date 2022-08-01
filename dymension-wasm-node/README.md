# Dymension-Wasm Node
Build and run dymension-wasm node
```sh
# inside the project folder:
docker build -t dymnesion-wasm-node .
docker run -it --rm -p 26657:26657 -p 26656:26656 -p 1317:1317 dymnesion-wasm-node /opt/setup_and_run_wasmd.sh
```
