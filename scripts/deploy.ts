import { ethers } from 'hardhat';

async function main() {
  // Specify the maximum supply for your NFTs
  const maxSupply = 1000;

  // Deploy the NFT contract with the specified maximum supply
  const nft = await ethers.deployContract('NFT', [maxSupply]);

  // Wait for the deployment to be confirmed
  await nft.waitForDeployment();

  console.log('NFT Contract Deployed at ' + nft.target);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
