// SPDX-License-Identifier: BSD-3-Clause
pragma solidity ^0.8.3;

import "./base/ERC721Tradable.sol";

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/**
 * @title Pengulet
 */
// TODO: add some sort of access control
contract Pengulet is ERC721Tradable {
    using Strings for uint256;
    using SafeMath for uint256;
    using Counters for Counters.Counter;

    Counters.Counter public tokenIds;
    string public apiURI;

    constructor(
        address _proxyRegistryAddress
    ) ERC721Tradable("Pengulet4", "PNGU4", _proxyRegistryAddress) {
        apiURI = "";
    }

    function setApiURI(string memory _uri) external {
        apiURI = _uri;
    }

    /**
     * @dev Mints a token to an address with a tokenURI.
     * @param _to address of the future owner of the token
     */
    function mintTo(address _to) public {
        tokenIds.increment();

        uint256 newItemId = tokenIds.current();
        _mint(_to, newItemId);
    }

    // TODO: contractURI

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        string memory baseURI = baseTokenURI();
        return
            bytes(baseURI).length > 0
                ? string(abi.encodePacked(baseURI, tokenId.toString()))
                : "";
    }

    function baseTokenURI() public view returns (string memory) {
        return apiURI;
    }
}
