// SPDX-License-Identifier: BSD-3-Clause
pragma solidity ^0.8.3;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "./base/ERC721TradableUpgradeable.sol";
import "./access/AccessControlUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";

/**
 * @title Pengulet
 */
contract PenguletUpgradeable is
    Initializable,
    ERC721TradableUpgradeable,
    AccessControlUpgradeable
{
    using StringsUpgradeable for uint256;
    using SafeMathUpgradeable for uint256;
    using CountersUpgradeable for CountersUpgradeable.Counter;

    CountersUpgradeable.Counter public tokenIds;
    string public apiURI;

    // TODO: Change back to normal naming
    function __Pengulet_init(address _proxyRegistryAddress) public initializer {
        __ERC721Tradable_init("Pengulet4", "PNGU4", _proxyRegistryAddress);
        __AccessControl_init_unchained();
        __Pengulet_init_unchained();
    }

    function __Pengulet_init_unchained() internal initializer {
        paused = true;

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
