ARG NODE_VERSION=16.15.0-alpine3.15
ARG REQUEST_NODE_VERSION=latest

FROM node:${NODE_VERSION} AS base
WORKDIR /node

FROM base AS build
ARG REQUEST_NODE_VERSION
RUN apk add --no-cache git python3 build-base
RUN npm install -g @requestnetwork/request-node@${REQUEST_NODE_VERSION}

FROM base
COPY --from=build /node /node
ENV PORT 3000
EXPOSE 3000

CMD ["request-node"]
