ARG TAG=main

FROM node:lts-alpine AS base
WORKDIR /app
RUN apk add --no-cache git
RUN apk add --no-cache -X https://dl-cdn.alpinelinux.org/alpine/edge/testing dockerize

FROM base AS build
RUN git clone https://github.com/RequestNetwork/storage-subgraph.git /app
RUN git checkout ${TAG}
RUN yarn
RUN yarn codegen ./subgraph-private.yaml

FROM base
ENV WEB3_URL=http://ganache:8545
ENV GRAPH_NODE_URL=http://graph-node:8020
ENV IPFS_URL=http://ipfs:5001
RUN npm install --production @graphprotocol/graph-cli@0.25.1 @graphprotocol/graph-ts@0.24.1
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
    && npx graph create --node ${GRAPH_NODE_URL} RequestNetwork/request-storage --access-token '' ./subgraph-private.yaml \
    && npx graph deploy --node ${GRAPH_NODE_URL} --ipfs ${IPFS_URL} RequestNetwork/request-storage --access-token '' --version-label v0.0.1 ./subgraph-private.yaml
