# build image
FROM node:lts-alpine AS build
WORKDIR /node
RUN npm install @requestnetwork/request-node@0.25.0

# final image
FROM node:lts-alpine
COPY --from=build /node /node
WORKDIR /node

ENV PORT 3000
EXPOSE 3000

CMD ["node", "/node/node_modules/@requestnetwork/request-node/dist/server.js"]
