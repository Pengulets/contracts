import { Contract } from '@ethersproject/contracts';
import { expect } from 'chai';
import { ethers, upgrades } from 'hardhat';

describe('Pengulet', function () {
    let contract: Contract;

    beforeEach(async function () {
        const PenguletUpgradeable = await ethers.getContractFactory('PenguletUpgradeable');
        contract = await upgrades.deployProxy(PenguletUpgradeable, ['0xf57b2c51ded3a29e6891aba85459d600256cf317'], { initializer: '__Pengulet_init' });
    });

    describe('initialization', () => {
        it('should correctly initialise apiURI and read baseTokenURI()', async () => {
            const apiURI: string = await contract.apiURI();
            expect(apiURI).to.equal('');

            const baseTokenURI: string = await contract.baseTokenURI();
            expect(baseTokenURI).to.equal('');

            expect(baseTokenURI).to.equal(apiURI);
        });

        it('should be paused by default', async () => {
            const paused: boolean = await contract.paused();
            expect(paused).to.equal(true);
        });
    });

    describe('setting values', () => {
        it('should correctly update apiURI and read apiURI, baseTokenURI()', async () => {
            const randomInput = Math.random().toString(36).substring(7);

            await contract.setApiURI(randomInput);

            const apiURI: string = await contract.apiURI();
            const baseTokenURI: string = await contract.baseTokenURI();

            expect(baseTokenURI).to.equal(randomInput);
            expect(apiURI).to.equal(randomInput);

            expect(baseTokenURI).to.equal(apiURI);
        });
    });
});
