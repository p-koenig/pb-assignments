require("@nomicfoundation/hardhat-toolbox");
require('dotenv').config({ path: require('path').resolve(__dirname, '../../.env') });

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.24",
  defaultNetwork: "custom",
  networks: {
    custom: {
      url: "http://134.155.50.125:8506",
      chainId: 1337,
      // accounts: [Buffer.from(process.env.METAMASK_1_PRIVATE_KEY, 'utf8').toString('hex')],
      accounts: [process.env.METAMASK_1_PRIVATE_KEY],
      gas: "auto",
      gasPrice: "auto",
      gasMultiplier: 1
    }
  }
};