// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract KittyNFT is ERC721URIStorage {
    struct Kitty {
        string name;
        uint256 genes;
        uint256 birthTime;
        uint256 parent1Id;
        uint256 parent2Id;
        uint256 generation;
    }

    uint256 private nextTokenId = 1;
    mapping(uint256 => Kitty) private kitties;

    event KittyCreated(
        uint256 indexed tokenId,
        address indexed owner,
        string name,
        uint256 genes,
        uint256 parent1Id,
        uint256 parent2Id,
        uint256 generation
    );

    constructor() ERC721("Academy Kitty", "AKITTY") {}

    function mintKitty(
        string memory name,
        uint256 genes,
        string memory metadataURI
    ) public returns (uint256 tokenId) {
        require(bytes(name).length > 0, "Name is required");

        tokenId = _createKitty(
            msg.sender,
            name,
            genes,
            0,
            0,
            0,
            metadataURI
        );
    }

    function breedKitty(
        uint256 parent1Id,
        uint256 parent2Id,
        string memory childName,
        string memory metadataURI
    ) public returns (uint256 tokenId) {
        require(parent1Id != parent2Id, "Choose different parents");
        require(ownerOf(parent1Id) == msg.sender, "Not parent 1 owner");
        require(ownerOf(parent2Id) == msg.sender, "Not parent 2 owner");
        require(bytes(childName).length > 0, "Name is required");

        Kitty storage parent1 = kitties[parent1Id];
        Kitty storage parent2 = kitties[parent2Id];

        uint256 childGenes = uint256(
            keccak256(
                abi.encodePacked(
                    parent1.genes,
                    parent2.genes,
                    msg.sender,
                    nextTokenId,
                    block.prevrandao
                )
            )
        );

        uint256 childGeneration =
            _max(parent1.generation, parent2.generation) + 1;

        tokenId = _createKitty(
            msg.sender,
            childName,
            childGenes,
            parent1Id,
            parent2Id,
            childGeneration,
            metadataURI
        );
    }

    function getKitty(
        uint256 tokenId
    ) public view returns (Kitty memory) {
        ownerOf(tokenId);
        return kitties[tokenId];
    }

    function totalKitties() public view returns (uint256) {
        return nextTokenId - 1;
    }

    function _createKitty(
        address recipient,
        string memory name,
        uint256 genes,
        uint256 parent1Id,
        uint256 parent2Id,
        uint256 generation,
        string memory metadataURI
    ) private returns (uint256 tokenId) {
        tokenId = nextTokenId;
        nextTokenId += 1;

        kitties[tokenId] = Kitty({
            name: name,
            genes: genes,
            birthTime: block.timestamp,
            parent1Id: parent1Id,
            parent2Id: parent2Id,
            generation: generation
        });

        _safeMint(recipient, tokenId);
        _setTokenURI(tokenId, metadataURI);

        emit KittyCreated(
            tokenId,
            recipient,
            name,
            genes,
            parent1Id,
            parent2Id,
            generation
        );
    }

    function _max(uint256 a, uint256 b) private pure returns (uint256) {
        return a >= b ? a : b;
    }
}
