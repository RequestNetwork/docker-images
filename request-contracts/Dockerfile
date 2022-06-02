ARG NODE_VERSION=16.14.0-alpine3.14
ARG TAG=master

FROM node:${NODE_VERSION} AS base
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
# NCC does not accept custom tsconfig files
# so we need to rename tsconfig.build.json to -> tsconfig.json
# see https://github.com/vercel/ncc/issues/385
RUN mv tsconfig.json tsconfig.parent.json \
  && mv tsconfig.build.json tsconfig.json \
  && sed -i 's/"extends": ".\/tsconfig"/"extends": ".\/tsconfig.parent"/' tsconfig.json \
  && ncc build scripts/test-deploy-all.ts \
    -o dist \
    -e hardhat \
    -e ethers \
    -e web3
# We have to copy those files because of a dynamic import in the superfluid lib
# see https://github.com/superfluid-finance/protocol-monorepo/blob/089010c1403a930c392435ec173dc37c76689cfc/packages/ethereum-contracts/scripts/libs/common.js#L292
RUN cp -a /app/node_modules/@superfluid-finance/ethereum-contracts/scripts/libs dist/libs
# This is to avoid running the detectTruffle() method which has even more dynamic imports
RUN sed -i 's/truffleDetected: detectTruffle()/truffleDetected: false/' dist/libs/common.js
RUN sed -i 's/detectTruffle,/detectTruffle: () => false,/' dist/libs/common.js

FROM base
ENV WEB3_URL=http://ganache:8545
RUN npm install --production \
    hardhat@2.4.1 \
    ethers@5.5.1 \
    @nomiclabs/hardhat-ethers@2.0.2 \
    # web3 is needed to deploy the superfluid protocol
    web3@1.7.3 \
    @nomiclabs/hardhat-web3@2.0.0
COPY hardhat.config.js /app
COPY --from=build /app/packages/smart-contracts/dist/index.js /app/deploy.js
COPY --from=build /app/packages/smart-contracts/dist/libs/ /app/libs/
COPY --from=build /app/packages/smart-contracts/build/ /app/build/
CMD dockerize \
    -wait "tcp://${WEB3_URL/http:\/\//}" \
    -timeout 60s \
    npx hardhat deploy --network private
