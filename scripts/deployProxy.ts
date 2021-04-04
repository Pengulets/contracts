import { ethers, upgrades } from 'hardhat';

async function main() {
    const Pengulet = await ethers.getContractFactory('Pengulet');

    // Start deployment, returning a promise that resolves to a contract object
    // TODO: Change between Rinkeby and Mainet
    const proxyAddress = '0xf57b2c51ded3a29e6891aba85459d600256cf317'; // OpenSea Rinkeby proxy adress

    const pengulet = await upgrades.deployProxy(Pengulet, [proxyAddress], { initializer: '__Pengulet_init' });
    await pengulet.deployed();
    console.log('Contract deployed to address:', pengulet.address);
}

main()
    .catch(error => {
        console.error(error);
        process.exit(1);
    });
