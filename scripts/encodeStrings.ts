import { ethers } from 'ethers';

const proposalNames = ["Proposal1", "Proposal2", "Proposal3"];
const encodedProposalNames = proposalNames.map(name => ethers.encodeBytes32String(name));

console.log(encodedProposalNames);