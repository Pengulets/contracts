import '@nomiclabs/hardhat-ethers';
import '@nomiclabs/hardhat-etherscan';
import '@nomiclabs/hardhat-solhint';
import '@nomiclabs/hardhat-waffle';
import '@openzeppelin/hardhat-upgrades';
import '@typechain/hardhat';
import 'hardhat-gas-reporter';
import 'hardhat-tracer';
import type { HardhatUserConfig } from 'hardhat/config';
import 'solidity-coverage';
import { etherscanApi, privateKey } from './config';

const config: HardhatUserConfig = {
	solidity: {
		version: '0.8.2',
		settings: {
			optimizer: {
				enabled: true
			}
		}
	},
	defaultNetwork: 'hardhat',
	networks: {
		hardhat: {
			// forking: {
			// 	url: 'https://bsc-dataseed.binance.org',
			// 	blockNumber: 11224630
			// }
		},
		testnet: {
			url: 'https://data-seed-prebsc-1-s1.binance.org:8545',
			chainId: 97,
			gasPrice: 20000000000,
			accounts: [`0x${privateKey}`]
		},
		mainnet: {
			url: 'https://bsc-dataseed.binance.org/',
			chainId: 56,
			gasPrice: 20000000000,
			accounts: [`0x${privateKey}`]
		}
	},
	etherscan: {
		apiKey: etherscanApi
	},
	gasReporter: {
		excludeContracts: ['mocks/'],
		showTimeSpent: true,
		currency: 'EUR'
	}
};

export default config;
