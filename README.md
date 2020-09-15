# Labyrinth

Smart contract game made with Solidity and Truffle. It will use a NodeJs app together with MongoDB to store the game's possible maps, IPFS to store maps images and a React app for displaying the frontend.
Docker compose will be used to run all apps together.

![alt text](./architecture.png?raw=true "Architecture")

## How to play

- A player should request to start the game
- The contract owner assigns a map randomly
- The player should move either left, right, top or backwards, according to the map
- If the player gets to the end of the map, the game finishes and its total moves are saved into the ranking

## Smart Contract

### Testnet - Ropsten

A .secret file should be placed at root directory with the mnemonics of your wallet, e.g: "face business large tissue", and a .infuraKey file with an Infura key to run its node. To load your wallet with ethers the following [faucet]("https://faucet.ropsten.be/") can be used.
To compile contract:

```
npm run compile
```

To deploy:

```
npm run deploy
```

### Localhost - running tests

For tests, [ganache-cli](https://github.com/trufflesuite/ganache-cli) was used and runned on port 8545.
To run tests:

```
npm run test
```




