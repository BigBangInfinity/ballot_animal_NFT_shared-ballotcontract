import { ethers, run } from "hardhat";
import { TokenizedBallot, TokenizedBallot__factory, MyToken, MyToken__factory } from "../typechain-types";

import * as dotenv from "dotenv";
dotenv.config();


async function main() {

    const provider = new ethers.JsonRpcProvider(process.env.RPC_ENDPOINT_URL ?? "");
    const wallet = new ethers.Wallet(process.env.PRIVATE_KEY ?? "", provider);
    const wallet2 = new ethers.Wallet(process.env.PRIVATE_KEY2 ?? "", provider);
    const wallet3 = new ethers.Wallet(process.env.PRIVATE_KEY3 ?? "", provider);
    const wallet4 = new ethers.Wallet(process.env.PRIVATE_KEY4 ?? "", provider);
    console.log(`Using address ${wallet.address}`);

    const contractAddress = "0xAE7B4276c4Eef71920ff429Ea20847B933401b58";
    const ballotFactory = new TokenizedBallot__factory(wallet);
    const ballotContract = ballotFactory.attach(
        contractAddress
    ) as TokenizedBallot;
    
    const walletAddresses = [
      wallet.address, wallet2.address, wallet3.address, wallet4.address
    ]
     
    for (const address of walletAddresses){
      let votes = await ballotContract.votingPower(address);
      console.log(`Wallet ${address} votes: ${ethers.formatUnits(votes)}`)
    } 
 

}


main().catch((err) => {
    console.error(err);
    process.exitCode = 1;
});