// SPDX-License-Identifier: BSD-3-Clause
pragma solidity ^0.8.3;

import "./ERC721Tradable.sol";
import "./access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/**
 * @title Pengulet
 */
contract Pengulet is ERC721Tradable, AccessControl {
    using Counters for Counters.Counter;

    Counters.Counter public tokenIds;

    constructor(address _proxyRegistryAddress) ERC721Tradable("Pengulet", "PNGU", _proxyRegistryAddress) {
        // the creator of the contract is the initial CEO
        ceoAddress = msg.sender;

        // the creator of the contract is also the initial COO
        cooAddress = msg.sender;
    }

    /**
     * @dev Mints a token to an address with a tokenURI.
     * @param _to address of the future owner of the token
     */
    function mintTo(address _to) public onlyCOO {
        tokenIds.increment();

        uint256 newItemId = tokenIds.current();
        _mint(_to, newItemId);
    }

    // TODO: baseTokenURI AND contractURI

    function baseTokenURI() public pure override returns (string memory) {
        return "";
    }
}
