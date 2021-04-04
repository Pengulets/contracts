// SPDX-License-Identifier: BSD-3-Clause
pragma solidity ^0.8.3;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";

abstract contract AccessControlUpgradeable is Initializable, ContextUpgradeable {
    // The addresses of the accounts (or contracts) that can execute actions within each roles.
    address private _ceoAddress;
    address private _cfoAddress;
    address private _cooAddress;

    /// @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
    bool public paused;

    event CEOTransferred(address indexed previousCEO, address indexed newCEO);
    event CFOTransferred(address indexed previousCFO, address indexed newCFO);
    event COOTransferred(address indexed previousCOO, address indexed newCOO);

    function __AccessControl_init() internal initializer {
        __Context_init_unchained();
        __AccessControl_init_unchained();
    }

    function __AccessControl_init_unchained() internal initializer {
        paused = false;
        address msgSender = _msgSender();

        _ceoAddress = msgSender;
        emit CEOTransferred(address(0), msgSender);

        _cfoAddress = msgSender;
        emit CFOTransferred(address(0), msgSender);

        _cooAddress = msgSender;
        emit COOTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current CEO.
     */
    function CEO() public view virtual returns (address) {
        return _ceoAddress;
    }

    /**
     * @dev Returns the address of the current CFO.
     */
    function CFO() public view virtual returns (address) {
        return _cfoAddress;
    }

    /**
     * @dev Returns the address of the current COO.
     */
    function COO() public view virtual returns (address) {
        return _cooAddress;
    }

    /// @dev Access modifier for CEO-only functionality
    modifier onlyCEO() {
        require(CEO() == _msgSender(), "AccessControl: caller is not the CEO");
        _;
    }

    /// @dev Access modifier for CFO-only functionality
    modifier onlyCFO() {
        require(CFO() == _msgSender(), "AccessControl: caller is not the CFO");
        _;
    }

    /// @dev Access modifier for COO-only functionality
    modifier onlyCOO() {
        require(COO() == _msgSender(), "AccessControl: caller is not the COO");
        _;
    }

    /// @dev Access modifier for CEO, CFO, and COO only functionality
    modifier onlyCLevel() {
        require(
            COO() == _msgSender() ||
            CEO() == _msgSender() ||
            CFO() == _msgSender(),
            "AccessControl: caller is not the CEO, CFO, or the COO"
        );
        _;
    }

    /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
    /// @param _newCEO The address of the new CEO
    function setCEO(address _newCEO) external onlyCEO {
        require(_newCEO != address(0), "AccessControl: new CEO is the zero address");

        emit CEOTransferred(_ceoAddress, _newCEO);

        _ceoAddress = _newCEO;
    }

    /// @dev Assigns a new address to act as the CFO. Only available to the current CEO.
    /// @param _newCFO The address of the new CFO
    function setCFO(address _newCFO) external onlyCEO {
        require(_newCFO != address(0), "AccessControl: new CFO is the zero address");

        emit CFOTransferred(_cfoAddress, _newCFO);

        _cfoAddress = _newCFO;
    }

    /// @dev Assigns a new address to act as the COO. Only available to the current CEO.
    /// @param _newCOO The address of the new COO
    function setCOO(address _newCOO) external onlyCEO {
        require(_newCOO != address(0), "AccessControl: new COO is the zero address");

        emit COOTransferred(_cooAddress, _newCOO);

        _cooAddress = _newCOO;
    }

    /*** Pausable functionality adapted from OpenZeppelin ***/

    /// @dev Modifier to allow actions only when the contract IS NOT paused
    modifier whenNotPaused() {
        require(!paused, "AccessControl: contract is currently paused");
        _;
    }

    /// @dev Modifier to allow actions only when the contract IS paused
    modifier whenPaused {
        require(paused, "AccessControl: contract is not currently paused");
        _;
    }

    /// @dev Called by any "C-level" role to pause the contract. Used only when
    ///  a bug or exploit is detected and we need to limit damage.
    function pause() external onlyCLevel whenNotPaused {
        paused = true;
    }

    /// @dev Unpauses the smart contract. Can only be called by the CEO, since
    ///  one reason we may pause the contract is when CFO or COO accounts are
    ///  compromised.
    /// @notice This is public rather than external so it can be called by
    ///  derived contracts.
    function unpause() public onlyCEO whenPaused {
        // can't unpause if contract was upgraded
        paused = false;
    }
}
