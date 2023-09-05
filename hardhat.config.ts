import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@openzeppelin/hardhat-upgrades";
import dotenv from "dotenv";

dotenv.config();

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.17",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  networks: {
    mumbai: {
      url: process.env.MUMBAI_TESTNET_RPC_URL,
      accounts:
        process.env.CONTRACT_DEPLOYER !== undefined
          ? [process.env.CONTRACT_DEPLOYER]
          : [],
    }
  },
  etherscan: {
    apiKey: {
      polygonMumbai:'C2JRX8UG5NHYUJND8GGECXJINBIT5YVDV4'
  }
}
};

export default config;
