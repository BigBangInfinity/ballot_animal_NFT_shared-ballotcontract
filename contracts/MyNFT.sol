// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Votes.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Base64.sol";


// Author: @janedoe

contract MyNFT is ERC721, ERC721Votes, ERC721Burnable, ERC721URIStorage, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    //new MINT FUNCTION
    uint256 private nextTokenId = 1; // Variable to track the next available token ID

    using Strings for uint256;
    string[] public emojis;
    string[] public colors;

    constructor() ERC721("MyNFT", "MyNFT") EIP712("MyNFT", "1") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);

        emojis.push(unicode"🐧");
        emojis.push(unicode"🐒");
        emojis.push(unicode"🐈");
        emojis.push(unicode"🐸");
        emojis.push(unicode"🦄");
        emojis.push(unicode"🐶");
        emojis.push(unicode"🐼");
        emojis.push(unicode"🐻");
        emojis.push(unicode"🐳");
        emojis.push(unicode"🐂");


        colors.push("#FF0000"); //red
        colors.push("#008000"); //green
        colors.push("#0000FF"); //blue
        colors.push("#FFFF00"); //yellow
        colors.push("#000000"); //black
        colors.push("#FFFFFF"); //white
        colors.push("#00FFFF"); //cyan
        colors.push("#FF00FF"); //Magenta
        colors.push("#C0C0C0"); //silver
        colors.push("#808080"); //gray            
    }

    function getNextTokenId() public view returns (uint256) {
        return nextTokenId;
    }

    //new MINT FUNCTION
    function safeMint(address to) public onlyRole(MINTER_ROLE) {
        uint256 randomNumber = getRandomNumber();
        uint256 unicodeId = randomNumber % 10;
        uint256 colorId = (randomNumber/10) % 10;
        uint256 rarityId = (randomNumber/100) % 10;
        uint256 genderId = (randomNumber/1000) % 2;
        mintFrom(to, unicodeId, colorId, rarityId, genderId);        
    }

    function mintFrom(address to, uint256 unicodeId, uint256 colorId, uint256 rarityId, uint256 genderId) internal {
        _safeMint(to, nextTokenId);
        updateMetaData(nextTokenId, unicodeId, colorId, rarityId, genderId);    
        nextTokenId++;
    }

    // Update MetaData
    function updateMetaData(uint256 tokenId, uint256 unicodeId, uint256 colorId, uint256 rarityId, uint256 genderId) public {
        // Create the SVG string
        string memory finalSVG = buildSVG(unicodeId, colorId);
        string memory rarity;
        string memory gender;
        if (rarityId == 0) {
            rarity = "rare";
        }
        else {
            rarity = "common";
        }

        if (genderId == 0) {
            gender = "male";
        }
        else {
            gender = "female";
        }
           
        // Base64 encode the SVG
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "Animal SVG",',
                        '"description": "Animal SVG NFTs",',
                        '"image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(finalSVG)), '",',
                        '"attributes": [',
                            '{"trait_type": "gender",',
                            '"value": "', gender ,'"},',
                            '{"trait_type": "rarity",',
                            '"value": "', rarity ,'"}',
                        ']}'
                    )
                )
            )
        );
        // Create token URI
        string memory finalTokenURI = string(
            abi.encodePacked("data:application/json;base64,", json)
        );
        // Set token URI
        _setTokenURI(tokenId, finalTokenURI);
    }


    // Build the SVG string
    function buildSVG(uint256  unicodeId, uint256 colorId) internal view returns (string memory) {


        // Create SVG rectangle with random color
        string memory headSVG = string(
            abi.encodePacked(
                "<svg xmlns='http://www.w3.org/2000/svg' version='1.1' xmlns:xlink='http://www.w3.org/1999/xlink' xmlns:svgjs='http://svgjs.com/svgjs' width='500' height='500' preserveAspectRatio='none' viewBox='0 0 500 500'> <rect width='100%' height='100%' fill='",
                colors[colorId],
                "' />"
            )
        );
        // Update emoji based on price
        string memory bodySVG = string(
            abi.encodePacked(
                "<text x='50%' y='50%' font-size='128' dominant-baseline='middle' text-anchor='middle'>",
                emojis[unicodeId],
                "</text>"
            )
        );
        // Close SVG
        string memory tailSVG = "</svg>";


        // Concatenate SVG strings
        string memory _finalSVG = string(
            abi.encodePacked(headSVG, bodySVG, tailSVG)
        );
        return _finalSVG;
    }



    // The following function is an override required by Solidity.
    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }


    function tokenURI(uint256 tokenId)
        public view override(ERC721, ERC721URIStorage) returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function getRandomNumber() public view returns (uint256 randomNumber) {
        randomNumber = block.prevrandao;
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
    ) public view override(ERC721, AccessControl, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
