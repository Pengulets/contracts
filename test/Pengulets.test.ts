import chai, { expect } from 'chai';
import { solidity } from 'ethereum-waffle';
import { ethers, upgrades } from 'hardhat';
import type { Pengulets, PenguletsExposed } from '../typechain';

chai.use(solidity);

describe('Pengulets', () => {
	let contract: Pengulets;
	let contractExposed: PenguletsExposed;

	beforeEach(async () => {
		const PenguletsContract = await ethers.getContractFactory('Pengulets');
		contract = (await upgrades.deployProxy(PenguletsContract, ['Pengulets', 'PNGU', 8192], {
			initializer: '__Pengulets_init',
			kind: 'uups'
		})) as Pengulets;

		const PenguletsExposedContract = await ethers.getContractFactory('PenguletsExposed');
		contractExposed = (await upgrades.deployProxy(PenguletsExposedContract, ['Pengulets-Exposed', 'PNGU-E', 8192], {
			initializer: '__PenguletsExposed_init',
			kind: 'uups'
		})) as PenguletsExposed;
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

	describe('permissions', () => {
		it('should fail to mint', async () => {
			const [, accountAlternative] = await ethers.getSigners();

			await expect(contract.connect(accountAlternative).mintNext(accountAlternative.address)).to.be.revertedWith(
				'Ownable: caller is not the owner'
			);
		});

		it('should authorize upgrade', async () => {
			const [, { address: temporaryImplementationAddress }] = await ethers.getSigners();

			await contractExposed.authorizeUpgrade(temporaryImplementationAddress);
			// expect('authorizeUpgrade').to.be.calledOnContract(contractExposed);
		});

		it('should fail to authorize upgrade', async () => {
			const [, accountAlternative, { address: temporaryImplementationAddress }] = await ethers.getSigners();

			await expect(contractExposed.connect(accountAlternative).authorizeUpgrade(temporaryImplementationAddress)).to.be.revertedWith(
				'Ownable: caller is not the owner'
			);
		});
	});

	describe('URI', () => {
		it('should correctly update baseURI and read baseURI', async () => {
			const randomInput = Math.random().toString(36).substring(7);

			await contract.setBaseURI(randomInput);

			const baseURI: string = await contract.baseURI();

			expect(baseURI).to.equal(randomInput);
		});

		it('should correctly mint, update baseURI, and read tokenURI', async () => {
			const [{ address }] = await ethers.getSigners();
			const randomInput = Math.random().toString(36).substring(7);

			await contract.mintNext(address);
			await contract.setBaseURI(randomInput);

			const baseURI: string = await contract.baseURI();
			const tokenURI: string = await contract.tokenURI(1);

			expect(baseURI).to.equal(randomInput);
			expect(tokenURI).to.equal(`${randomInput}${1}`);
		});

		it('should correctly update baseURI, and fail to read tokenURI', async () => {
			const randomInput = Math.random().toString(36).substring(7);

			await contract.setBaseURI(randomInput);

			const baseURI: string = await contract.baseURI();

			expect(baseURI).to.equal(randomInput);

			await expect(contract.tokenURI(1)).to.be.revertedWith('ERC721Metadata: URI query for nonexistent token');
		});
	});

	describe('minting', () => {
		it('should mint maximum and fail going over', async () => {
			const [, { address: alternativeAddress }] = await ethers.getSigners();
			await contractExposed.mintAll();

			await expect(contractExposed.mintNext(alternativeAddress)).to.be.revertedWith('Max supply');
		}).timeout(100000);
	});
});
