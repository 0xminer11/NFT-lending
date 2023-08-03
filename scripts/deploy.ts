const { ethers,upgrades } = require("hardhat");

async function main() {
  const market = await ethers.getContractFactory("LendingMarket");
  const proxy = await upgrades.deployProxy( market,{ initializer: 'initialize' })
  console.log("tx",proxy)
  console.log("Proxy Contract Address:", proxy.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
