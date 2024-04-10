ARG NODE_VERSION=18.19.0-alpine3.19
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
