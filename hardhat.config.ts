require('dotenv').config();
import { HardhatUserConfig } from "hardhat/config";
import '@nomiclabs/hardhat-ganache';
import '@nomiclabs/hardhat-ethers';
import '@openzeppelin/hardhat-upgrades';
import '@nomiclabs/hardhat-etherscan';
// import 'hardhat-gas-reporter';
import 'solidity-coverage';

const { API_URL, PRIVATE_KEY, ETHERSCAN_API } = process.env;

const config: HardhatUserConfig = {
  solidity: {
    version: '0.8.3',
    settings: {
      optimizer: {
        enabled: true,
        runs: 50000
      }
    }
  },
  defaultNetwork: 'rinkeby',
  networks: {
    hardhat: {},
    rinkeby: {
      url: API_URL,
      accounts: [`0x${PRIVATE_KEY}`]
    },
    localhost: {
      url: "http://127.0.0.1:7545"
    }
  },
  etherscan: {
    apiKey: ETHERSCAN_API
  }
};

export default config;
