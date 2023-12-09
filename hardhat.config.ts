import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import dotenv from "dotenv";
dotenv.config(); // This loads the .env file at the start of your script


const config: HardhatUserConfig = {
  solidity: "0.8.19",

  etherscan: {
    // Your API key for Etherscan
    // Obtain one at https://etherscan.io/
    apiKey: process.env.ETHERSCAN_API_KEY
  },
  networks: {
    sepolia: {
      url: process.env.RPC_ENDPOINT_URL, // Sepolia RPC URL
      accounts: [process.env.PRIVATE_KEY as string], // Private key for the deploying account
    },
    // ... other networks ...
  },

  // sourcify: {
  //   // Disabled by default
  //   // Doesn't need an API key
  //   enabled: true
  // }
};

export default config;
