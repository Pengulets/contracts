async function main() {
    const Pengulet = await ethers.getContractFactory('Pengulet');

    // Start deployment, returning a promise that resolves to a contract object
    // TODO: Change between Rinkeby and Mainet
    const pengulet = await Pengulet.deploy('0xf57b2c51ded3a29e6891aba85459d600256cf317'); // OpenSea Rinkeby proxy adress
    console.log('Contract deployed to address:', pengulet.address);
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });
