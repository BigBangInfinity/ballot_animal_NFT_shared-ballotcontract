// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Votes.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

// Author: @janedoe

contract MyNFT is ERC721, ERC721Votes, ERC721Burnable, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    //new MINT FUNCTION
    uint256 private nextTokenId = 1; // Variable to track the next available token ID

    constructor() ERC721("MyNFT", "MyNFT") EIP712("MyNFT", "1") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
    }

    function getNextTokenId() public view returns (uint256) {
        return nextTokenId;
    }

    //new MINT FUNCTION
    function safeMint(address to) public onlyRole(MINTER_ROLE) {
        _safeMint(to, nextTokenId);
        nextTokenId++;
    }

    // function safeMint(
    //     address to,
    //     uint256 tokenId
    // ) public onlyRole(MINTER_ROLE) {
    //     _safeMint(to, tokenId);
    // }

    // The following functions are overrides required by Solidity.

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 firstTokenId,
        uint256 batchSize
    ) internal override(ERC721, ERC721Votes) {
        super._afterTokenTransfer(from, to, firstTokenId, batchSize);
    }


    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
