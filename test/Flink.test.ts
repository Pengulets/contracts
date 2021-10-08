import chai, { expect } from 'chai';
import { solidity } from 'ethereum-waffle';
import { ethers, upgrades } from 'hardhat';
import type { Flink } from '../typechain';

chai.use(solidity);

describe('Flink', () => {
	let contract: Flink;

	beforeEach(async () => {
		const FlinkContract = await ethers.getContractFactory('Flink');
		contract = (await upgrades.deployProxy(FlinkContract, [], { initializer: '__Flink_init', kind: 'uups' })) as Flink;
	});

	describe('initialization', () => {
		it('should set sender as owner', async () => {
			const [{ address }] = await ethers.getSigners();
			const owner = await contract.owner();

			expect(owner).to.equal(address);
		});
	});

	describe('ownable', () => {
		it('should swap ownership', async () => {
			const [, { address: addressAlternative }] = await ethers.getSigners();

			await contract.transferOwnership(addressAlternative);
			const owner = await contract.owner();

			expect(owner).to.equal(addressAlternative);
		});

		it('should fail to swap ownership', async () => {
			const [, accountAlternative] = await ethers.getSigners();

			await expect(contract.connect(accountAlternative).transferOwnership(accountAlternative.address)).to.be.revertedWith(
				'Ownable: caller is not the owner'
			);
		});
	});
});
