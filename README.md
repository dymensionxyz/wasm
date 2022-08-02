# dYmension Flagship
Dymension optimistic rollup built using the RDK and dymint

## Contract Preparation
Compile the smart contract you want to deploy, then:
```sh
WASM_FILE=<wasm-file-name>
WORKING_DIRECTORY=<contract-working-directory>
```

Optimize the compiled contract (as we want it to be as small as possible) by the following command:
```sh
docker run --rm -v "$WORKING_DIRECTORY":/code \
  --mount type=volume,source="$(basename "$WORKING_DIRECTORY")_cache",target=/code/target \
  --mount type=volume,source=registry_cache,target=/usr/local/cargo/registry \
  cosmwasm/rust-optimizer:0.12.6
```
This will compile the code inside `artifacts` directory.
