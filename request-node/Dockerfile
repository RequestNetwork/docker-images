ARG VERSION=latest

FROM node:lts-alpine AS base
WORKDIR /node

FROM base AS build
RUN npm install @requestnetwork/request-node@${VERSION}

FROM base
COPY --from=build /node /node
ENV PORT 3000
EXPOSE 3000
CMD ["node", "/node/node_modules/@requestnetwork/request-node/dist/server.js"]
