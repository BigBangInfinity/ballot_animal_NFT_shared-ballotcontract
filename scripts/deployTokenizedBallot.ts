import { ethers, run } from "hardhat";
import { TokenizedBallot__factory } from "../typechain-types";
import * as dotenv from "dotenv";
dotenv.config();


async function main() {

    const provider = new ethers.JsonRpcProvider(process.env.RPC_ENDPOINT_URL ?? "");
    const wallet = new ethers.Wallet(process.env.PRIVATE_KEY ?? "", provider);
    console.log(`Using address ${wallet.address}`);

    const myTokenAddress = "0x11e1B946c16A35CB45C8E93137A2A592FcE9dba6";
    const proposalNames = ["Bored Ape Yacht Club", "CryptoKitties", "Pudgy Penguins"];

    // Convert proposal names to bytes32 arrays
    const ProposalNames: string[] = proposalNames.map((proposalNames) => ethers.encodeBytes32String(proposalNames));


    const contractFactory = new TokenizedBallot__factory(wallet);
    const contract = await contractFactory.deploy(ProposalNames, myTokenAddress);
    await contract.waitForDeployment();
    const contractAddress = contract.target;
    console.log(`Token contract deployed at ${contractAddress}\n`);

}


main().catch((err) => {
    console.error(err);
    process.exitCode = 1;
});