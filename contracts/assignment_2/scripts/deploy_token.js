// scripts/deploy_token.js

const hre = require("hardhat");
const ethers = hre.ethers;

async function main() {

    const [ownerC] = await ethers.getSigners();
    console.log("The address of the owner is: ", ownerC.address);

    const token = await ethers.getContractFactory("CensorableToken");
    const cont = await token.deploy("CensorableToken","CTK",100, ownerC.address)
    console.log("Contract deployed to:", cont.target);

    await cont.waitForDeployment();
}

main()
.then(() => process.exit(0))
.catch(error => {
  console.error(error);
  process.exit(1);
});