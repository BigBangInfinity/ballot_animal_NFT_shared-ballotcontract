import { ethers } from 'ethers';

const proposalNames = ["Bored Ape Yacht Club", "CryptoPunks", "Pudgy Penguins"];
const encodedProposalNames = proposalNames.map(name => ethers.encodeBytes32String(name));

console.log(encodedProposalNames);