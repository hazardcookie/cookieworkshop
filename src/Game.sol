// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

/// @title Hazard's Cookies
/// @author @hazardcookie
contract Game is ERC721 {
  // Custom errors
  error NotEnoughFunds();
  error RefundFailed();

  // State variables
  uint256 public constant COOKIE_OF_WEALTH = 1;
  uint256 public lastPrice;

  // Constructor mints 1 cookie
  constructor() ERC721("Hazards Cookies", "COOKIES") {
    _mint(msg.sender, COOKIE_OF_WEALTH);
  }

  /// @notice Buy the Cookie of Wealth
  /// @dev To buy the Cookie of Wealth, send more ETH than the last price
  function buyCookieOfWealth() external payable {
    // Check that the sent value is greater than the last price
    // If not, revert the transaction
    if (msg.value < lastPrice) {
      revert NotEnoughFunds();
    }

    // Get the previous owner
    address payable previousOwner = payable(ownerOf(COOKIE_OF_WEALTH));

    // Calculate the ETH refund
    uint256 refund = lastPrice;

    // Transfer ownership of the cookie to the new owner
    _transfer(previousOwner, msg.sender, COOKIE_OF_WEALTH);

    // Update the last price to the new price
    lastPrice = msg.value;

    // Send the previous owner their refund
    // If this fails, revert the transaction and revert the transfer of ownership
    if (refund > 0) {
      (bool success,) = previousOwner.call{ value: refund }("");
      if (!success) {
        revert RefundFailed();
      }
    }
  }
}
