ARG TAG=master

FROM node:lts-alpine AS base
WORKDIR /app
RUN apk add --no-cache git
RUN apk add --no-cache -X https://dl-cdn.alpinelinux.org/alpine/edge/testing dockerize

FROM base AS build
ARG TAG
RUN yarn global add @vercel/ncc
RUN git clone https://github.com/RequestNetwork/requestNetwork.git /app
RUN git checkout ${TAG}
RUN yarn
RUN yarn workspace @requestnetwork/types run build
RUN yarn workspace @requestnetwork/currency run build
WORKDIR /app/packages/smart-contracts
RUN yarn build:sol
RUN ncc build scripts/5_deploy-all.ts -o dist

FROM base
ENV WEB3_URL=http://ganache:8545
RUN npm install --production hardhat @nomiclabs/hardhat-ethers ethers
COPY hardhat.config.js /app
COPY --from=build /app/packages/smart-contracts/dist/index.js /app/deploy.js
COPY --from=build /app/packages/smart-contracts/build /app/build
CMD dockerize \
    -wait "tcp://${WEB3_URL/http:\/\//}" \
    -timeout 60s \
    npx hardhat deploy --network private
