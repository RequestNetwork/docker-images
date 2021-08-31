const { task } = require("hardhat/config");
// import the compile "deploy.ts"
const deploy = require("./deploy").default;

const web3Url = process.env.WEB3_URL || "ganache";
const web3Port = process.env.WEB3_PORT || 8545;
module.exports = {
  paths: {
    artifacts: "build",
  },
  networks: {
    private: {
      url: "http://127.0.0.1:8545",
      accounts: undefined,
    },
    web3: {
      url: `http://${web3Url}:${web3Port}`,
      accounts: undefined,
    },
  },
};

task("deploy", "Deploy Request Contracts").setAction(async (args, hre) => {
  args.force = true;
  await deploy(args, hre);
  console.log("All contracts deployed locally");
});
