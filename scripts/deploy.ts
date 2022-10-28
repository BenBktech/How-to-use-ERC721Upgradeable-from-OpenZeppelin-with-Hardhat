import { ethers, upgrades } from "hardhat";

async function main() {
  const BenBKNFT = await ethers.getContractFactory("BenBKNFT");
  const benBKNFT = await BenBKNFT.deploy();

  await benBKNFT.deployed();

  console.log(`Deployed to ${benBKNFT.address}`);

  const Proxy = await upgrades.deployProxy(BenBKNFT, ["ipfs://CID/"], {kind: 'uups' })
  await Proxy.deployed();
  console.log(`Deployed to ${Proxy.address}`);
  //const marsV2 = await hre.upgrades.upgradeProxy(mars, this.MarsV2);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});