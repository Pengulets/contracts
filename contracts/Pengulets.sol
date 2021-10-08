// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.2;

import '@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol';
import '@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol';
import '@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol';
import '@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol';
import '@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol';

import '@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol';
import '@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol';
import '@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol';

contract Pengulets is Initializable, ERC721Upgradeable, ERC721EnumerableUpgradeable, OwnableUpgradeable, UUPSUpgradeable {
	using StringsUpgradeable for uint256;
	using SafeMathUpgradeable for uint256;
	using CountersUpgradeable for CountersUpgradeable.Counter;

	string public baseURI;

	CountersUpgradeable.Counter public tokenIds;

	function __Pengulets_init(string memory _name, string memory _symbol) public initializer {
		__ERC721_init(_name, _symbol);
		__ERC721Enumerable_init();
		__Ownable_init();
		__UUPSUpgradeable_init();
		__Pengulets_init_unchained();
	}

	function __Pengulets_init_unchained() internal initializer {}

	function mintTo(address _to) public onlyOwner {
		tokenIds.increment();

		uint256 newItemId = tokenIds.current();
		_mint(_to, newItemId);
	}

	function setBaseURI(string memory newURI) public onlyOwner {
		baseURI = newURI;
	}

	function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
		require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');

		string memory baseURI_ = _baseURI();
		return bytes(baseURI_).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
	}

	function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721Upgradeable, ERC721EnumerableUpgradeable) returns (bool) {
		return super.supportsInterface(interfaceId);
	}

	function _beforeTokenTransfer(
		address from,
		address to,
		uint256 tokenId
	) internal virtual override(ERC721Upgradeable, ERC721EnumerableUpgradeable) {
		super._beforeTokenTransfer(from, to, tokenId);
	}

	function _baseURI() internal view virtual override returns (string memory) {
		return baseURI;
	}

	/**
	 * @dev More information about this can be found at https://docs.openzeppelin.com/contracts/4.x/api/proxy#UUPSUpgradeable
	 */
	function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}
