import { ethers, upgrades } from 'hardhat';
import type { Flink } from '../typechain';

async function main() {
	const FlinkContract = await ethers.getContractFactory('Flink');

	const flink = (await upgrades.deployProxy(FlinkContract, [], { initializer: '__Flink_init', kind: 'uups' })) as Flink;

	await flink.deployed();

	console.log('Contract deployed to address:', flink.address);
}

main().catch((error) => {
	console.error(error);
	process.exit(1);
});
