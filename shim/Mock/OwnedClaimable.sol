// SPDX-License-Identifier: MIT
// Inspired by OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)

pragma solidity 0.8.17;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be passed in the constructor. This
 * can later be changed with {transferOwnership} and {acceptOwnership}.
 *
 * This module is used through inheritance. It will make available all functions
 * from parent (Ownable).
 */
abstract contract OwnedClaimable {

    error Unauthorized();
    error InvalidParams();

    address private _owner;
    address private _pendingOwner;

    event OwnershipTransferStarted(address indexed previousOwner, address indexed newOwner);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting `owner` as the initial owner.
     */
    constructor(address _initialOwner) {
      if (_initialOwner == address(0)) revert InvalidParams();

      _transferOwnership(_initialOwner);
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
      _checkOwner();
      _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
      return _owner;
    }

    /**
     * @dev Returns the address of the pending owner.
     */
    function pendingOwner() public view virtual returns (address) {
      return _pendingOwner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
      if (owner() != msg.sender) revert Unauthorized();
    }

    /**
     * @dev Starts the ownership transfer of the contract to a new account. Replaces the pending transfer if there is one.
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        _pendingOwner = newOwner;
        emit OwnershipTransferStarted(owner(), _pendingOwner);
    }


    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
      delete _pendingOwner;
      address oldOwner = _owner;
      _owner = newOwner;
      emit OwnershipTransferred(oldOwner, _owner);
    }

    /**
     * @dev The new owner accepts the ownership transfer.
     */
    function acceptOwnership() external {
      if (pendingOwner() != msg.sender) revert Unauthorized();
      _transferOwnership(msg.sender);
    }
}
