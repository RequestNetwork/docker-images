const { task } = require("hardhat/config");
// import the compile "deploy.ts"
const deploy = require("./deploy").default;

console.log("web3:" + process.env.WEB3_URL);
module.exports = {
  paths: {
    artifacts: "build",
  },
  networks: {
    private: {
      url: process.env.WEB3_URL || "http://127.0.0.1:8545",
      accounts: undefined,
    },
  },
};

task("deploy", "Deploy Request Contracts").setAction(async (args, hre) => {
  args.force = true;
  await deploy(args, hre);
  console.log("All contracts deployed locally");
});
