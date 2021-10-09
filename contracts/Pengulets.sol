// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.2;

import '@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol';
import '@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol';
import '@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol';
import '@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol';
import '@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol';

import '@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol';
import '@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol';

contract Pengulets is Initializable, ERC721Upgradeable, ERC721EnumerableUpgradeable, OwnableUpgradeable, UUPSUpgradeable {
	using StringsUpgradeable for uint256;
	using SafeMathUpgradeable for uint256;

	uint256 public MAX_PNGU;

	string public baseURI;

	mapping(uint256 => uint256) public lastTransferTimestamp;
	mapping(address => uint256) private pastCumulativeHODL;

	function __Pengulets_init(
		string memory _name,
		string memory _symbol,
		uint256 maxSupply
	) public initializer {
		__ERC721_init(_name, _symbol);
		__ERC721Enumerable_init();
		__Ownable_init();
		__UUPSUpgradeable_init();
		__Pengulets_init_unchained(maxSupply);
	}

	function __Pengulets_init_unchained(uint256 maxSupply) internal initializer {
		MAX_PNGU = maxSupply;
	}

	function mint(address to, uint256 tokenId) public virtual onlyOwner {
		_safeMint(to, tokenId);
	}

	function mintNext(address to) public virtual onlyOwner {
		uint256 supply = totalSupply();
		mint(to, supply + 1);
	}

	function cumulativeHODL(address user) public view returns (uint256) {
		uint256 _cumulativeHODL = pastCumulativeHODL[user];
		uint256 bal = balanceOf(user);
		for (uint256 i = 0; i < bal; i++) {
			uint256 tokenId = tokenOfOwnerByIndex(user, i);
			uint256 timeHodld = block.timestamp - lastTransferTimestamp[tokenId];
			_cumulativeHODL += timeHodld;
		}
		return _cumulativeHODL;
	}

	function setBaseURI(string memory newURI) public onlyOwner {
		baseURI = newURI;
	}

	function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
		require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');

		string memory baseURI_ = _baseURI();
		return bytes(baseURI_).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
	}

	/* istanbul ignore next */
	function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721Upgradeable, ERC721EnumerableUpgradeable) returns (bool) {
		return super.supportsInterface(interfaceId);
	}

	function _safeMint(address to, uint256 tokenId) internal virtual override {
		require(tokenId < MAX_PNGU, 'Max supply');
		super._safeMint(to, tokenId);
	}

	function _beforeTokenTransfer(
		address from,
		address to,
		uint256 tokenId
	) internal virtual override(ERC721Upgradeable, ERC721EnumerableUpgradeable) {
		super._beforeTokenTransfer(from, to, tokenId);

		uint256 timeHodld = block.timestamp - lastTransferTimestamp[tokenId];
		if (from != address(0)) {
			pastCumulativeHODL[from] += timeHodld;
		}
		lastTransferTimestamp[tokenId] = block.timestamp;
	}

	function _baseURI() internal view virtual override returns (string memory) {
		return baseURI;
	}

	/**
	 * @dev More information about this can be found at https://docs.openzeppelin.com/contracts/4.x/api/proxy#UUPSUpgradeable
	 */
	function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}
