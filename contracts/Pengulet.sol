// SPDX-License-Identifier: BSD-3-Clause
pragma solidity ^0.8.3;

import "./ERC721Tradable.sol";
import "./access/AccessControl.sol";
import "./utils/StringConcat.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/**
 * @title Pengulet
 */
contract Pengulet is ERC721Tradable, AccessControl {
    using StringConcat for string;
    using Strings for string;
    using SafeMath for uint256;
    using Counters for Counters.Counter;

    Counters.Counter public tokenIds;
    string public apiURI;

    constructor(address _proxyRegistryAddress) ERC721Tradable("Pengulet", "PNGU", _proxyRegistryAddress) {
        // the creator of the contract is the initial CEO
        ceoAddress = msg.sender;

        // the creator of the contract is also the initial COO
        cooAddress = msg.sender;

        apiURI = "";
    }

    function setApiURI(string memory _uri) external onlyCEO {
        apiURI = _uri;
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

    // TODO: contractURI

    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        return StringConcat.strConcat(baseTokenURI(), Strings.toString(_tokenId));
    }

    function baseTokenURI() public view returns (string memory) {
        return apiURI;
    }
}
