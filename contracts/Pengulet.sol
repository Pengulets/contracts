// SPDX-License-Identifier: BSD-3-Clause
pragma solidity ^0.8.3;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "./ERC721TradableUpgradeable.sol";
import "./access/AccessControlUpgradeable.sol";

import "./utils/StringConcat.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/**
 * @title Pengulet
 */
contract Pengulet is Initializable, ERC721TradableUpgradeable, AccessControlUpgradeable {
    using StringConcat for string;
    using Strings for string;
    using SafeMath for uint256;
    using Counters for Counters.Counter;

    Counters.Counter public tokenIds;
    string public apiURI;

    // TODO: Change back to normal naming
    function __Pengulet_init(address _proxyRegistryAddress) internal initializer {
        __ERC721Tradable_init("Pengulet2", "PNGU2", _proxyRegistryAddress);
        __AccessControl_init_unchained();
        __Pengulet_init_unchained();
    }

    function __Pengulet_init_unchained() internal initializer {
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
