ARG NODE_VERSION=16.15.0-alpine3.15
ARG STORAGE_SUBGRAPH_TAG=main

FROM node:${NODE_VERSION} AS base
WORKDIR /app
RUN apk add --no-cache git
RUN apk add --no-cache -X https://dl-cdn.alpinelinux.org/alpine/edge/testing dockerize

FROM base AS build
ARG STORAGE_SUBGRAPH_TAG
RUN git clone https://github.com/RequestNetwork/storage-subgraph.git /app
RUN git checkout ${STORAGE_SUBGRAPH_TAG}
RUN yarn
RUN yarn codegen ./subgraph-private.yaml

FROM base
ENV WEB3_URL=http://ganache:8545
ENV GRAPH_NODE_URL=http://graph-node:8020
ENV IPFS_URL=http://ipfs:5001
RUN npm install --production @graphprotocol/graph-cli@0.54.0 @graphprotocol/graph-ts@0.31.0
COPY --from=build /app/abis/ /app/abis/
COPY --from=build /app/generated/ /app/generated/
COPY --from=build /app/src/ /app/src/
COPY --from=build /app/schema.graphql /app/schema.graphql
COPY --from=build /app/subgraph-private.yaml /app/subgraph-private.yaml
CMD dockerize \
    -wait "tcp://${WEB3_URL/http:\/\//}" \
    -wait "tcp://${GRAPH_NODE_URL/http:\/\//}" \
    -wait "${IPFS_URL}/api/v0/version" \
    -timeout 60s \
    echo "web3 up" \
    && npx graph create --node ${GRAPH_NODE_URL} RequestNetwork/request-storage --access-token '' \
    && npx graph deploy --node ${GRAPH_NODE_URL} --ipfs ${IPFS_URL} RequestNetwork/request-storage --access-token '' --version-label v0.0.1 ./subgraph-private.yaml
