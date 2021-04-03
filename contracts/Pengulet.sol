// SPDX-License-Identifier: BSD-3-Clause
pragma solidity ^0.8.3;

import "./ERC721Tradable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Pengulet
 */
contract Pengulet is ERC721Tradable {
    constructor(address _proxyRegistryAddress) ERC721Tradable("Pengulet", "PNGU", _proxyRegistryAddress) {}

    // TODO: baseTokenURI AND contractURI
}
