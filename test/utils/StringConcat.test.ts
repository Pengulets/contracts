import { Contract } from '@ethersproject/contracts';
import { expect } from 'chai';
import { ethers } from 'hardhat';

describe('StringConcat', function () {
    let contract: Contract;

    beforeEach(async function () {
        const StringConcat = await ethers.getContractFactory('StringConcatMock');
        contract = await StringConcat.deploy();
    });

    it('should concatanate 2 strings', async () => {
        const input1 = Math.random().toString(36).substring(7);
        const input2 = Math.random().toString(36).substring(7);

        const strConcat2: string = await contract.strConcat2(input1, input2);

        expect(strConcat2).to.equal(`${input1}${input2}`)
    });

    it('should concatanate 3 strings', async () => {
        const input1 = Math.random().toString(36).substring(7);
        const input2 = Math.random().toString(36).substring(7);
        const input3 = Math.random().toString(36).substring(7);

        const strConcat3: string = await contract.strConcat3(input1, input2, input3);

        expect(strConcat3).to.equal(`${input1}${input2}${input3}`)
    });

    it('should concatanate 4 strings', async () => {
        const input1 = Math.random().toString(36).substring(7);
        const input2 = Math.random().toString(36).substring(7);
        const input3 = Math.random().toString(36).substring(7);
        const input4 = Math.random().toString(36).substring(7);

        const strConcat4: string = await contract.strConcat4(input1, input2, input3, input4);

        expect(strConcat4).to.equal(`${input1}${input2}${input3}${input4}`)
    });

    it('should concatanate 5 strings', async () => {
        const input1 = Math.random().toString(36).substring(7);
        const input2 = Math.random().toString(36).substring(7);
        const input3 = Math.random().toString(36).substring(7);
        const input4 = Math.random().toString(36).substring(7);
        const input5 = Math.random().toString(36).substring(7);

        const strConcat5: string = await contract.strConcat5(input1, input2, input3, input4, input5);

        expect(strConcat5).to.equal(`${input1}${input2}${input3}${input4}${input5}`)
    });

});
