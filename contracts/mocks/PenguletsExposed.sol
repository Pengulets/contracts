// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.2;

import '../Pengulets.sol';

import '@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol';

contract PenguletsExposed is Initializable, Pengulets {

	function __PenguletsExposed_init(string memory _name, string memory _symbol) public initializer {
		__Pengulets_init(_name, _symbol);
		__PenguletsExposed_init_unchained();
	}

	function __PenguletsExposed_init_unchained() internal initializer {}

	function authorizeUpgrade(address newImplementation) public onlyOwner {
        return super._authorizeUpgrade(newImplementation);
    }
}
