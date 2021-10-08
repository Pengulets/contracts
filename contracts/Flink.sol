// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.2;

import '@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol';
import '@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol';
import '@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol';
import '@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20BurnableUpgradeable.sol';
import '@openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol';
import '@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol';

contract Flink is Initializable, ERC20Upgradeable, ERC20BurnableUpgradeable, OwnableUpgradeable, UUPSUpgradeable {
	using SafeERC20Upgradeable for IERC20Upgradeable;

	function __Flink_init() public initializer {
		__ERC20_init('Flink', 'FLINK');
		__ERC20Burnable_init_unchained();
		__Ownable_init();
		__UUPSUpgradeable_init();
		__Flink_init_unchained();
	}

	function __Flink_init_unchained() internal initializer {}

	function mint(address to, uint256 amount) public onlyOwner {
		_mint(to, amount);
	}

	/**
	 * @dev More information about this can be found at https://docs.openzeppelin.com/contracts/4.x/api/proxy#UUPSUpgradeable
	 */
	function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}
