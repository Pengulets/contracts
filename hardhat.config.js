require('dotenv').config();
require('@nomiclabs/hardhat-ethers');

// TODO: Implement https://hardhat.org/plugins/nomiclabs-hardhat-etherscan.html

const { API_URL, PRIVATE_KEY } = process.env;

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: '0.8.3',
  defaultNetwork: 'rinkeby',
  networks: {
    hardhat: {},
    rinkeby: {
      url: API_URL,
      accounts: [`0x${PRIVATE_KEY}`]
    }
  }
};
