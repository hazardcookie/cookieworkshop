// SPDX-License-Identifier: UNLICENSED
pragma solidity ^ 0.8 .13;

// Contracts
import "../src/Game.sol";

// Testing Libraries
import "forge-std/Test.sol";
import "forge-std/Vm.sol";

contract GameTest is Test {
  // Variable setup
  Game public cookies;
  address payable _bob = payable(address(0x1234));
  address payable _alice = payable(address(0x5678));
  uint256 public constant DEAL_AMOUNT = 5 ether;
  uint256 public constant SMOL_BUY_AMOUNT = 1 ether;
  uint256 public constant LARGE_BUY_AMOUNT = 2 ether;

  /// @notice setups Game contract for testing
  /// @dev _bob is the address of the player buying the cookies
  /// @notice DEAL_AMOUNT is 5 ether
  function setUp() public {
    cookies = new Game();
    emit log_named_address("Contract Address", address(cookies));
    emit log_named_address("Cookie owner", cookies.ownerOf(1));
    vm.deal(_bob, DEAL_AMOUNT);
    vm.deal(_alice, DEAL_AMOUNT);
  }

  /// @notice Tests the buyCookieOfWealth function
  /// @dev Cookie of Wealth is NFT #5 and should be owned by _bob
  function testBuyCookieOfWealth() public {
    // _bob buys Cookie of Wealth
    vm.startPrank(address(_bob));
    cookies.buyCookieOfWealth{ value: SMOL_BUY_AMOUNT }();
    emit log_string("NFT Owners: ");
    vm.stopPrank();

    // _bob should own Cookie of Wealth
    assertEq(cookies.ownerOf(1), _bob);

    // Log NFT owners after _bob buys Cookie of Wealth
    address owner = cookies.ownerOf(1);
    emit log_named_address("Cookie of wealth owner", owner);
  }

  /// @notice Tests the buyCookieOfWealth function with _alice buying from _bob
  function testStealCookieOfWealth() public {
    // _bob buys Cookie of Wealth to setup test
    vm.startPrank(address(_bob));
    cookies.buyCookieOfWealth{ value: SMOL_BUY_AMOUNT }();

    // log contracts balance
    emit log_named_uint("Contract Balance Before: ", address(this).balance);

    // stop acting as _bob
    vm.stopPrank();

    // _bob should own Cookie of Wealth
    assertEq(cookies.ownerOf(1), _bob);

    // Log NFT owners after _bob buys Cookie of Wealth
    emit log_named_address("Cookie of wealth owner", cookies.ownerOf(1));

    // _alice buys Cookie of Wealth from _bob
    vm.startPrank(address(_alice));
    cookies.buyCookieOfWealth{ value: LARGE_BUY_AMOUNT }();
    vm.stopPrank();

    // _alice should own Cookie of Wealth
    assertEq(cookies.ownerOf(1), _alice);

    // Log NFT owners after _alice buys Cookie of Wealth
    emit log_named_address("Cookie of wealth owner", cookies.ownerOf(1));

    // log contracts balance
    emit log_named_uint("Contract Balance After: ", address(this).balance);

    // log _bob's balance
    emit log_named_uint("_bob's Balance: ", _bob.balance);

    // _bob should have his ether returned back
    assertEq(_bob.balance, DEAL_AMOUNT);

    /// _alice should own Cookie of Wealth
    assertEq(cookies.ownerOf(1), _alice);

    // Stop acting as _bob
    vm.startPrank(address(_bob));

    // Anticipated revert because _bob does not have enough ether
    vm.expectRevert(Game.NotEnoughFunds.selector);

    // _bob tries to buy Cookie of Wealth from _bob
    cookies.buyCookieOfWealth{ value: SMOL_BUY_AMOUNT }();

    // Stop acting as _bob
    vm.stopPrank();

    // _alice should still own Cookie of Wealth
    assertEq(cookies.ownerOf(1), _alice);

    // Log NFT owners after _bob tries to buy Cookie of Wealth
    emit log_named_address("Cookie of wealth owner", cookies.ownerOf(1));

    // _alice should not have her ether returned back
    assertEq(_alice.balance, DEAL_AMOUNT - LARGE_BUY_AMOUNT);
  }
}
