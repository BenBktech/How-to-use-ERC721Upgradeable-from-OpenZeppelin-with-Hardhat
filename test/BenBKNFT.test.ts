import hre from 'hardhat' 
import assert from 'assert'
import { util } from 'chai'
import { ethers } from 'ethers'

before('get factories', async function() {
  this.BenBKNFTV1 = await hre.ethers.getContractFactory('BenBKNFT')
  this.BenBKNFTV2 = await hre.ethers.getContractFactory('BenBKNFTV2')
})

it('Should deploy the first smart contract and then the upgrade it', async function() {
  //this line deploys the implementation (mars contract), it then deploys a proxy admin and then it deploys the proxy connecting of all that together
  const BenBKNFT = await hre.upgrades.deployProxy(this.BenBKNFTV1, ["ipfs://CID/"], {kind: 'uups' })
  assert(await BenBKNFT.name() === 'BenBKNFT')
  assert(await BenBKNFT.baseURI() === 'ipfs://CID/')

  const BenBKV2 = await hre.upgrades.upgradeProxy(BenBKNFT, this.BenBKNFTV2);
  let maxSupply = await BenBKV2.MAX_SUPPLY()
  maxSupply = maxSupply.toString()
  assert(maxSupply === '50')
})