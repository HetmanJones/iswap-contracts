import { config as dotenv } from "dotenv";

dotenv();

import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

import "hardhat-deploy";

const AURORA_TESTNET_URL = process.env.AURORA_TESTNET_URL;

if (!AURORA_TESTNET_URL) {
  console.warn("AURORA_TESTNET_URL not specified");
}

const config: HardhatUserConfig = {
  paths: {
    sources: "./src"
  },
  namedAccounts: {
    deployer: 0
  },
  solidity: "0.8.17",
  networks: {
    "aurora-testnet": {
      url: `${AURORA_TESTNET_URL}`,
      accounts: {
        mnemonic: `${process.env.AURORA_TESTNET_MNEMONIC}`,
      },
      chainId: 1313161555,
      gasPrice: 120 * 1000000000
    },
  }
};

export default config;
