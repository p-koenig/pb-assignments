const hre = require("hardhat");
const {ethers} = require("ethers");

require("dotenv").config({ path: "../../.env" });


async function main() {
    const currentTimestampInSeconds = Math.round(Date.now() / 1000);
    const unlockTime = currentTimestampInSeconds + 60;

    const initQ = ["What is the capital of France?", "What is the capital of Germany?", "What is the capital of Italy?", "What is the capital of Spain?", "What is the capital of Portugal?"];
    const initA = ["Paris", "Berlin", "Rome", "Madrid", "Lisbon"];

    // const quiz = await hre.ethers.deployContract("MyQuiz", [initQ, initA], {value: ethers.parseEther("0.5")});
    const quiz = await hre.ethers.deployContract("MyQuiz", [initQ, initA]);

    await quiz.waitForDeployment();

    console.log(`MyQuiz at ${unlockTime} deployed to: ${quiz.target}`);
}

main()