//
// This file exists only to simplify the build of the ./scripts/* files into a single file using NCC
//
import "@nomiclabs/hardhat-ethers";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import deployRequest from "./scripts/1_deploy-request-storage";
import deployPayment from "./scripts/2_deploy-main-payments";
import deployConversion from "./scripts/3_deploy_chainlink_contract";

export default async function deploy(
  args: any,
  hre: HardhatRuntimeEnvironment
) {
  await deployRequest(args, hre);
  await deployPayment(args, hre);
  await deployConversion(args, hre);
}
