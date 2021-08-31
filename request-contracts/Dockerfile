# build image
FROM node:lts AS build
WORKDIR /app

RUN yarn global add @vercel/ncc

RUN git clone --depth 1 --branch master https://github.com/RequestNetwork/requestNetwork.git /app
RUN yarn
RUN yarn workspace @requestnetwork/types run build
RUN yarn workspace @requestnetwork/currency run build
WORKDIR /app/packages/smart-contracts
RUN yarn build:sol
COPY ./deploy.ts .
RUN ncc build deploy.ts -o dist

# final image
FROM node:lts-alpine
WORKDIR /app

RUN npm i hardhat @nomiclabs/hardhat-ethers ethers 

COPY wait-for /app
COPY hardhat.config.js /app
COPY --from=build /app/packages/smart-contracts/dist/index.js /app/deploy.js
COPY --from=build /app/packages/smart-contracts/build /app/build

CMD ["./node_modules/bin/hardhat","deploy","--network", "web3"]