// SPDX-License-Identifier: UNLICENSED
pragma solidity ^ 0.8 .13;

// Contracts
import "../src/Game.sol";

// Testing Libraries
import "forge-std/Test.sol";
import "forge-std/Vm.sol";

contract GameTest is Test {
    Game public cookies;

    function setUp() public {
        cookies = new Game();
    }

    function testCookieOwner() public {
        emit log_named_address("Contract Address", address(cookies));
        emit log_named_address("Cookie owner", cookies.ownerOf(1));
        assertEq(cookies.ownerOf(1), address(this));
    }
}
