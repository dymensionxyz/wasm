# Dymension-Wasm Node
Build and run dymension-wasm node
```sh
# inside the project folder:
docker build -t dymnesion-wasm-node .
docker run -it --rm -p 26657:26657 -p 26656:26656 -p 1317:1317 dymnesion-wasm-node /opt/setup_and_run.sh
```
Run dymension-wasm server
```sh
# inside the project folder:
python3 dymension-wasm-node/wasm_server.py 8001 dymn-devnet
```

