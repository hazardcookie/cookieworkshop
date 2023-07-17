// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "lib/openzeppelin-contracts/contracts/utils/Base64.sol";

// @title Hazard's Cookies
// @author @hazardcookie
// @notice This NFT contract has 5 cookies, each claimable with different conditions
contract HazardsCookies is ERC721 {
  // Custom errors
  error NotEnoughFunds();
  error RefundFailed();
  error BlockNumberMustBeEven();
  error NumberMustBeGreater();
  error MustWaitOneWeek();
  error BlockMustEndIn420();
  error NoMetaData();
  error InvalidID();

  uint256 public constant COOKIE_OF_POWER = 1;
  uint256 public constant COOKIE_OF_WISDOM = 2;
  uint256 public constant COOKIE_OF_TIME = 3;
  uint256 public constant COOKIE_OF_WAR = 4;
  uint256 public constant COOKIE_OF_WEALTH = 5;

  uint256 public lastPrice;
  uint256 public lastTime;
  uint256 public lastNumber;

  struct Cookie {
    string color;
    string name;
  }

  Cookie[5] public cookies;

  constructor() ERC721("Hazards Cookies", "COOKIES") {
    cookies[COOKIE_OF_POWER - 1] = Cookie("#ff8dc0", "Power");
    cookies[COOKIE_OF_WISDOM - 1] = Cookie("#cc96f0", "Wisdom");
    cookies[COOKIE_OF_TIME - 1] = Cookie("#A581FA", "Time");
    cookies[COOKIE_OF_WAR - 1] = Cookie("#899EF8", "War");
    cookies[COOKIE_OF_WEALTH - 1] = Cookie("#98E7FF", "Wealth");

    for (uint256 i = 0; i <= 4; i++) {
      _mint(msg.sender, i + 1);
    }
    lastTime = block.timestamp;
  }

  function buyCookieOfWealth() external payable {
    // Check that the sent value is greater than the last price
    // If not, revert the transaction
    if (msg.value <= lastPrice) {
      revert NotEnoughFunds();
    }

    address payable previousOwner = payable(ownerOf(COOKIE_OF_WEALTH));
    uint256 refund = lastPrice;

    _transfer(previousOwner, msg.sender, COOKIE_OF_WEALTH);
    lastPrice = msg.value;

    if (refund > 0) {
      (bool success,) = previousOwner.call{ value: refund }("");
      if (!success) {
        revert RefundFailed();
      }
    }
  }

  function takeCookieOfWar() external {
    if (block.number % 2 != 0) {
      revert BlockNumberMustBeEven();
    }
    _transfer(ownerOf(COOKIE_OF_WAR), msg.sender, COOKIE_OF_WAR);
  }

  function takeCookieOfTime() external {
    if (block.timestamp - lastTime < 1 weeks) {
      revert MustWaitOneWeek();
    }
    lastTime = block.timestamp;
    _transfer(ownerOf(COOKIE_OF_TIME), msg.sender, COOKIE_OF_TIME);
  }

  function takeCookieOfWisdom(uint256 number) external {
    if (number < lastNumber) {
      revert NumberMustBeGreater();
    }
    lastNumber = number;
    _transfer(ownerOf(COOKIE_OF_WISDOM), msg.sender, COOKIE_OF_WISDOM);
  }

  function takeCookieOfPower() external {
    uint16 lastThreeDigits = uint16(block.number % 1000);
    if (lastThreeDigits != 420) {
      revert BlockMustEndIn420();
    }
    _transfer(ownerOf(COOKIE_OF_POWER), msg.sender, COOKIE_OF_POWER);
  }

  function _getSVG(uint256 tokenId) private view returns (string memory) {
    if (tokenId < 1 || tokenId > 5) {
      revert InvalidID();
    }

    return string(
      abi.encodePacked(
        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base{fill:',
        cookies[tokenId - 1].color,
        ';font-family:sans-serif;font-size:14px}</style><rect width="100%" height="100%" fill="',
        cookies[tokenId - 1].color,
        '"/><text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">',
        cookies[tokenId - 1].name,
        "</text></svg>"
      )
    );
  }

  modifier tokenExists(uint256 tokenId) {
    if (!_exists(tokenId)) {
      revert NoMetaData();
    }
    _;
  }

  function tokenURI(uint256 tokenId)
    public
    view
    override
    tokenExists(tokenId)
    returns (string memory)
  {
    string memory svg = Base64.encode(bytes(_getSVG(tokenId)));
    string memory json = Base64.encode(
      bytes(
        string(
          abi.encodePacked(
            '{"name": "Cookie of ',
            cookies[tokenId - 1].name,
            '", "description": "Hazards Cookies", "image": "data:image/svg+xml;base64,',
            svg,
            '"}'
          )
        )
      )
    );
    return string(abi.encodePacked("data:application/json;base64,", json));
  }

  /// @notice returns the owners of all the cookies
   /// @return address[] owners of the cookies
  function getCookieOwners() public view returns(address[] memory) {
      address[] memory owners = new address[](5);
      for (uint256 i = 0; i < 5; i++) {
          owners[i] = ownerOf(i + 1);
      }
      return owners;
    }
}
