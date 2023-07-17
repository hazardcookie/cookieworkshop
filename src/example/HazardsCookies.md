## Functionality
The following details provide a deeper understanding of the functions within the Solidity Bootcamp's smart contract for the `Hazards Cookies` NFT game:
​
The contract inherits from `OpenZeppelin's ERC721 contract` and defines various types of cookies, each with a unique ID. It uses the `Base64.sol` library to handle base64 encoding, which is required for token metadata generation.
​
**buyCookieOfWealth()**: This function allows a user to buy the 'Cookie of Wealth'. In order to buy the cookie of wealth, the caller of this function must pay more than the previous owner. If the function call is succesful, the cookie will be transfered to the new owner, and the previous owner will be refunded their money (stored in lastPrice). If the transaction fails, the contract reverts and refunds the function caller.

**takeCookieOfWar()**: This function allows a user to take the 'Cookie of War'. The user can only take this cookie when the current block number is even.
​
**takeCookieOfTime()**: This function allows a user to take the `Cookie of Time`. A user must wait for a week from the last time this cookie was taken.
​
**takeCookieOfWisdom(uint256 number)**: This function allows a user to take the `Cookie of Wisdom`. To take this cookie, the user must provide a number greater than the last number provided when this function was last called.
​
**takeCookieOfPower()**: This function allows a user to take the 'Cookie of Power'. A user can only take this cookie when the last three digits of the current block number are `420`.
​
`_getSVG(uint256 tokenId`: This is a private helper function used to generate an SVG for each token. SVG data is used for token metadata.
​
`tokenUri(uint256 tokenId)`: This function overrides the tokenUri function in the inherited ERC721 contract. It returns a base64 encoded SVG of the token.
​
The smart contract also maintains, lastPrices, lastNumber, lastTime, and colors state variables.lastPrices is the price at which the `Cookie of Wealth` was last bought. lastNumber is the last number provided when `takeCookieOfWisdom()` was called. lastTime is the timestamp when `takeCookieOfTime()` was last called. colors is a string array storing the colors of the cookies.