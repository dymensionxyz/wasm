FROM golang:1.18.4-alpine3.16 as go-builder

WORKDIR /app

# Install required celestia node packages
ENV PACKAGES curl tar wget clang jq git ncdu make libc-dev bash gcc linux-headers eudev-dev python3

RUN apk add --no-cache $PACKAGES

# Install celestia node and cel-key commands
RUN git clone https://github.com/celestiaorg/celestia-node.git

WORKDIR /app/celestia-node

RUN git checkout tags/v0.3.0-rc1

RUN make build && make cel-key

COPY celestia-test-key.pk .

FROM alpine:3.16.1

COPY --from=go-builder /app/celestia-node/build/celestia /usr/local/bin/
COPY --from=go-builder /app/celestia-node/cel-key /usr/local/bin/
COPY --from=go-builder /app/celestia-node/celestia-test-key.pk .

ENV CELESTIA_BRIDGE_NODE_ENDPOINT=rpc-mamaki.pops.one:9090
ENV WALLET_KEY_NAME=dymension-test

# Init the node
RUN celestia light init --core.grpc $CELESTIA_BRIDGE_NODE_ENDPOINT

# Fetch the key for celestia light node and sleep for a few seconds
RUN echo '12345678' | cel-key import $WALLET_KEY_NAME ./celestia-test-key.pk --keyring-backend test --node.type light

EXPOSE 26658 9090

## Print the key and Run the light node with the dymension-test key
CMD celestia light start --core.grpc $CELESTIA_BRIDGE_NODE_ENDPOINT --keyring.accname $WALLET_KEY_NAME
