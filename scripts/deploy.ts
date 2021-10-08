import { ethers, upgrades } from 'hardhat';
import type { Pengulets } from '../typechain';

async function main() {
	const PenguletsContract = await ethers.getContractFactory('Pengu');

	const pengulets = (await upgrades.deployProxy(PenguletsContract, ['Pengulets', 'PNGU'], {
		initializer: '__Pengulets_init',
		kind: 'uups'
	})) as Pengulets;

	await pengulets.deployed();

	console.log('Contract deployed to address:', pengulets.address);
}

main().catch((error) => {
	console.error(error);
	process.exit(1);
});
