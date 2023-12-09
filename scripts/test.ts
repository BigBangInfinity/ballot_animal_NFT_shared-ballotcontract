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

    //const contractAddress = "0x0f1a44e8e0b59723890008989f103E05C9ec7FB5";
    const contractAddress = "0x9aC2703a812b45c240CF39AE3E3224D765001648 ";
    const ballotFactory = new TokenizedBallot__factory(wallet);
    const ballotContract = ballotFactory.attach(
        contractAddress
    ) as TokenizedBallot;
    
    let length = 3;
    for (let index = 0; index < length; index++){
      let proposal = await ballotContract.proposals(index);
      console.log(`${ethers.decodeBytes32String(proposal.name)} votes: ${proposal.voteCount.toString()}`)
    }


    // const tokenContractAddress = "0x79459FE8c4240E508633b2E8cFcE48280798C2BE";
    // const tokenFactory = new MyToken__factory(wallet);
    // const tokenContract = tokenFactory.attach(
    //     tokenContractAddress
    // ) as MyToken;
    // const votes = await tokenContract.getVotes(wallet.address);
    // console.log(`Wallet votes: ${ethers.formatUnits(votes)}`)

    // const txDelegate = await tokenContract.delegate(wallet.address);
    // txDelegate.wait();
    // const votes2 = await tokenContract.getVotes(wallet.address);
    // console.log(`Wallet votes: ${ethers.formatUnits(votes2)}`);

    // const votes3 = await tokenContract.getPastVotes(wallet.address, 4680911);
    // console.log(`Wallet votes: ${ethers.formatUnits(votes3)}`);
    

    // const balance = await tokenContract.balanceOf(wallet.address);
    // const balance2 = await tokenContract.balanceOf(wallet2.address);
    // const balance3 = await tokenContract.balanceOf(wallet3.address);
    // const balance4 = await tokenContract.balanceOf(wallet4.address);
    // console.log(`Balance Wallet 1: ${ethers.formatUnits(balance)}`);
    // console.log(`Balance Wallet 2: ${ethers.formatUnits(balance2)}`);
    // console.log(`Balance Wallet 3: ${ethers.formatUnits(balance3)}`);
    // console.log(`Balance Wallet 4: ${ethers.formatUnits(balance4)}`);

    // await ballotContract.vote(1, ethers.parseUnits("1"));

    const tokenContractAddress = "0x79459FE8c4240E508633b2E8cFcE48280798C2BE";
    const tokenFactory2 = new MyToken__factory(wallet2);
    const tokenContract2 = tokenFactory2.attach(
        tokenContractAddress
    ) as MyToken;
    const votes2 = await tokenContract2.getVotes(wallet2.address);
    console.log(`Wallet votes: ${ethers.formatUnits(votes2)}`)
    const txDelegate2 = await tokenContract2.delegate(wallet.address);
    txDelegate2.wait(5);

    const ballotFactory2 = new TokenizedBallot__factory(wallet2);
    const ballotContract2 = ballotFactory2.attach(
        contractAddress
    ) as TokenizedBallot;
        
    await ballotContract2.vote(2, ethers.parseUnits("1"));

    for (let index = 0; index < length; index++){
      let proposal = await ballotContract.proposals(index);
      console.log(`${ethers.decodeBytes32String(proposal.name)} votes: ${proposal.voteCount.toString()}`)
    }

}


main().catch((err) => {
    console.error(err);
    process.exitCode = 1;
});