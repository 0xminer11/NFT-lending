const { ethers,upgrades } = require("hardhat");

async function main() {

  const NFT = await ethers.getContractFactory("Alpha");
  const nativeToken =await NFT.deploy()
  await nativeToken.deployed();

  const market = await ethers.getContractFactory("LendingMarket");
  const proxy = await market.deploy('0x3E45fBb7228bCCCE4BB95cD402162C71FDE8f592')
  await proxy.deployed()
  // const proxy = await upgrades.deployProxy( market,['0x3E45fBb7228bCCCE4BB95cD402162C71FDE8f592'],{ initializer: 'initialize' })
  // // console.log("tx",proxy)
  // console.log("Native Token Address:", nativeToken.address);
  console.log("market Token Address:", proxy.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});


// Lending Market : 0xA719eC4A7595F53E0BF9cD2366Cd87FFd30331aB
// NativeToken : 0x3E45fBb7228bCCCE4BB95cD402162C71FDE8f592