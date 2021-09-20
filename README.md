# 🦹‍♀️🧑‍🎓👨‍🚒 Roles Framework 🧜‍♀️🧛👸

Programmatically define user roles based on live blockchain data. You can set thresholds based on ERC-20 or ERC-721 balances, and mix and match to custom-gate certain functions in Soldity or your favorite web app.

## Getting Started

See `packages/hardhat/RolesFramework.sol` for the deployable implementations of the IRolesFramework interface. In `packages/hardhat/RolesFrameworkBase.sol`, the core logic and interfaces are defined, so you can use those to design your own smart contracts or web apps to consume Roles Framework.

## Testing

In `packages/hardhat/deploy/00_deploy_your_contract.js`, set the address to your own wallet address to try the mutable version.

Run `yarn` to install dependencies. Then, in three separate terminal windows, run the following commands:

```
yarn chain
```

```
yarn compile
yarn deploy
```

```
yarn start
```

This will start a local blockchain, compile and deploy the contracts, and start the React app to start testing the contract.

For more info on how to use this repository, check out [scaffold-eth](https://github.com/scaffold-eth/scaffold-eth)

## Contributing

PR's and issues welcome! All contributions are subject to MIT license. If you want to help and don't know how to get started, open an issue!

## License

The license for this repository can be found in [LICENSE](./LICENSE).