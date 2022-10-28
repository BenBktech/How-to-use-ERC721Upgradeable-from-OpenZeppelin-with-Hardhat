import { ethers, upgrades, network } from "hardhat";
import { verify } from "../utils/verify"
import { readFileSync, writeFileSync, promises as fsPromises } from 'fs';

async function main() {
  const BenBKNFT = await ethers.getContractFactory("BenBKNFT");
  const benBKNFT = await BenBKNFT.deploy();

  await benBKNFT.deployed();

  console.log(`Deployed to ${benBKNFT.address}`);

  const Proxy = await upgrades.deployProxy(BenBKNFT, ["ipfs://CID/"], {kind: 'uups' })
  let putProxyInfosInFile = await writeFileSync('./ProxyInfos.json', JSON.stringify(Proxy, null, 2) , 'utf-8');
  await Proxy.deployed();
  console.log(`Deployed to ${Proxy.address}`);
  //const marsV2 = await hre.upgrades.upgradeProxy(mars, this.MarsV2);

  if(network.name === "goerli") {
    await verify(benBKNFT.address, [])
    await verify(Proxy.address, [])
  }
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});