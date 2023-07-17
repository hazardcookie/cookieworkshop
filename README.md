# University of Waterloo Solidity Bootcamp - Foundry, Solidity, XRPL EVM Sidechain
​
## Table of Contents
- [Description](#Description)
- [Prerequisites](#Prerequisites)
- [Installation](#Installation)
- [Functionality](#Functionality)
- [Notes](#Notes)
- [Support](#Support)
​
## Description
Welcome to the readme for the University of Waterloo's Solidity Bootcamp conducted on July 17th. This bootcamp focuses on Foundry, Solidity, and XRPL EVM Sidechain hosted by Ripple.
​
The primary objective of this workshop is to explore the 'Hazards Cookies' NFT game, which provides a real-world context to apply and dive deep into Solidity concepts. Participants will learn the process of deploying and interacting with smart contracts, understanding their potential and limitations, and developing a robust understanding of the Solidity programming language.
​
## Prerequisites
Before you begin, ensure you have met the following requirements:
​
You have installed the latest version of [RUST](https://www.rust-lang.org/tools/install), [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git), and [Visual Studio Code](https://code.visualstudio.com/download)
You have a basic understanding of Solidity and Blockchain concepts
​
## Installation
To install and setup the University of Waterloo Solidity Bootcamp environment, follow these steps:
​
Install Foundry by following the instructions provided [here](https://foundry.readthedocs.io/en/latest/getting-started.html#install).
​
Access the bridge at [XRPL Bridge](https://bridge.devnet.xrpl.org/).
​
Create a [Metamask](https://metamask.io/download.html) wallet to connect to the bridge. Bridge some testnet XRP to your wallet.
​
Export the private key from Metamask, you will use this in your Foundry project to deploy a contract to the devnet.

## Functionality
The following details provide a deeper understanding of the functions within the Solidity Bootcamp's smart contract for the `Hazards Cookies` NFT game:
​
The contract inherits from `OpenZeppelin's ERC721 contract` and defines various a "Cookie" NFT, with a unique ID. 
​
**buyCookieOfWealth()**: This function allows a user to buy the 'Cookie of Wealth'. In order to buy the cookie of wealth, the caller of this function must pay more than the previous owner. If the function call is succesful, the cookie will be transfered to the new owner, and the previous owner will be refunded their money (stored in lastPrice). If the transaction fails, the contract reverts and refunds the function caller.

## Deploying the Game Contract
### Deploy to Anvil
```
export PRIVATE_KEY=<local-anvil-private-key>
```
```
forge script script/Game.s.sol:GameDeploy --fork-url http://localhost:8545 \
--private-key $PRIVATE_KEY --broadcast
```

### Deploy to XRPL EVM Sidechain
```
export PRIVATE_KEY=<your-testnet-private-key>
```
```
$ forge create --rpc-url https://rpc-evm-poa-sidechain.peersyst.tech/ \
    --private-key $PRIVATE_KEY \
    src/Game.sol:Game
```

### Verify the contract with the following command:
```
forge verify-contract  --chain-id 1440002 --verifier=blockscout \
--verifier-url=https://evm-poa-sidechain.peersyst.tech/api 0x0D3aacc4332c15Aeaf663e68054a9F56a9E97646 src/Game.sol:Game
```

### To submit flattened contract for verification, use the following command and submit the generated flat.sol file to the verification service:
```
forge flatten src/Game.sol -o flat.sol
```

## Notes
## Functionality
This project was built primarily for educational purposes and may not be fully optimized for production use. It's a great environment for learning, exploration and experimentation. The **buyCookieOfWealth** function and its associated Solidity concepts are the primary areas of focus. To checkout the full contract, check `src/example/HazardCookie.sol` and `src/example/HazardsCookies.md`.
​
This project was built for educational purposes and may not be ready for production use.
​
## Support
If you encounter any problems or have any questions, feel free to contact us at @hazardcookie on Twitter or eavci@ripple.com. We are here to help you through this learning journey!