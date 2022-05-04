ARG NODE_VERSION=16.14.0-alpine3.14
ARG REQUEST_NODE_VERSION=latest

FROM node:${NODE_VERSION} AS base
WORKDIR /node

FROM base AS build
ARG REQUEST_NODE_VERSION
RUN npm install @requestnetwork/request-node@${REQUEST_NODE_VERSION}

FROM base
COPY --from=build /node /node
ENV PORT 3000
EXPOSE 3000
CMD ["node", "/node/node_modules/@requestnetwork/request-node/dist/server.js"]
