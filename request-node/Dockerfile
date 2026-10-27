ARG NODE_VERSION=22.23.4-alpine3.23@sha256:6abbcf5dd6b231da109bcde1181db1d92bf78015ae1a9514d9807c1f857869db
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
