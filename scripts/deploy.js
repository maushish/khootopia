const hre = require("hardhat");

async function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

async function main() {
  const ChatApp = await hre.ethers.deployContract("ChatApp");
  await ChatApp.waitForDeployment();
  console.log("Contract deployed to:", ChatApp.target);



  await sleep(30 * 1000);


}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});