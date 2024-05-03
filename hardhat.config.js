require("@nomicfoundation/hardhat-toolbox");
require('dotenv').config({ path: require('path').resolve(__dirname, '.env') });

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.24",
  defaultNetwork: "custom",
  networks: {
    custom: {
      url: "http://134.155.50.136:8506",
      chainId: 1337,
      // accounts: [Buffer.from(process.env.METAMASK_1_PRIVATE_KEY, 'utf8').toString('hex')],
      accounts: [process.env.METAMASK_1_PRIVATE_KEY, "579c67a525969f29bd677585ffe8217eec9dfc616b769e3c83723a7fdc4e73af", "e50bfc5f4b6c1711b96d90d45fa98852b1ff882ecb3983730a934dda14e7a0fa"],
      gas: "auto",
      gasPrice: "auto",
      gasMultiplier: 1
    },
  }
};