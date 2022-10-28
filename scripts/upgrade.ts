import { ethers, upgrades, network } from "hardhat";
import { verify } from "../utils/verify"
import hre from 'hardhat'
import { readFileSync, writeFileSync, promises as fsPromises } from 'fs';

async function main() {
    const BenBKNFTV2 = await ethers.getContractFactory("BenBKNFTV2");
    const ProxyInfos = readFileSync('./ProxyInfos.json', {encoding:'utf8', flag:'r'});
    const ProxyInfosObject = JSON.parse(ProxyInfos)
    const Deployment = await hre.upgrades.upgradeProxy(ProxyInfosObject, BenBKNFTV2);
    await Deployment.deployed()
    console.log(`Deployed to address : ${Deployment.address}`)

    let version = await Deployment.version();
    console.log(version)

    if(network.name === "goerli") {
        await verify(Deployment.address, [])
    }
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});