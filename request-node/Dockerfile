ARG NODE_VERSION=22.23.5-alpine3.23@sha256:6868d4695b947ee120bffaa463fecd68cde370d7bfec92955e7c8ac576b4f475
ARG REQUEST_NODE_VERSION=latest

FROM node:${NODE_VERSION} AS base
WORKDIR /node

FROM base AS build
ARG REQUEST_NODE_VERSION
RUN apk add --no-cache git python3 build-base
RUN npm install @requestnetwork/request-node@${REQUEST_NODE_VERSION}

FROM base
COPY --from=build /node /node

ENV PORT 3000
EXPOSE 3000

ENTRYPOINT []
CMD ["/node/node_modules/.bin/request-node"]
