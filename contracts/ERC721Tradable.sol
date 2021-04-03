// SPDX-License-Identifier: BSD-3-Clause
pragma solidity ^0.8.3;

import "./utils/StringConcat.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract OwnableDelegateProxy {}

contract ProxyRegistry {
    mapping(address => OwnableDelegateProxy) public proxies;
}

contract ERC721Tradable is ERC721, Ownable {
    using StringConcat for string;
    using Strings for string;
    using SafeMath for uint256;
    using Counters for Counters.Counter;

    address proxyRegistryAddress;
    Counters.Counter public tokenIds;

    constructor(
        string memory _name,
        string memory _symbol,
        address _proxyRegistryAddress
    ) ERC721(_name, _symbol) {
        proxyRegistryAddress = _proxyRegistryAddress;
    }

    /**
     * @dev Mints a token to an address with a tokenURI.
     * @param _to address of the future owner of the token
     */
    function mintTo(address _to) public onlyOwner {
        tokenIds.increment();

        uint256 newItemId = tokenIds.current();
        _mint(_to, newItemId);
    }

    function baseTokenURI() public pure returns (string memory) {
        return "";
    }

    function tokenURI(uint256 _tokenId) public pure override returns (string memory) {
        return StringConcat.strConcat(baseTokenURI(), Strings.toString(_tokenId));
    }

    /**
     * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-less listings.
     */
    function isApprovedForAll(address owner, address operator) public view override returns (bool) {
        // Whitelist OpenSea proxy contract for easy trading.
        ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
        if (address(proxyRegistry.proxies(owner)) == operator) {
            return true;
        }

        return super.isApprovedForAll(owner, operator);
    }
}
