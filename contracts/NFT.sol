// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFT is ERC721, Ownable {
    uint256 public counter;
    uint256 public maxSupply;
    mapping(address => bool) public minted;
    mapping(uint256 => string) private _tokenURIs;

    // IPFS hash for the star image
    string private constant STAR_IMAGE_IPFS_HASH = "QmV3yaPUv61zheFg25nDWzA7vuhxyo4QsArwsBbykAqSBy";

    constructor(
        uint256 _maxSupply
    ) ERC721("Loyalty", "LOY") Ownable(msg.sender) {
        maxSupply = _maxSupply;
    }

    function mintFor(address _recipient) public onlyOwner {
        require(counter < maxSupply, "MaxSupplyReached");
        require(!minted[_recipient], "OneMintPerAddress");

        minted[_recipient] = true;
        counter++;
        _safeMint(_recipient, counter);

        // Set the same IPFS hash for every minted NFT directly in the mapping
        // All tokens sharing the same metadata (tokenURI) here (same gold star) so the below is unnecessary but good practice if making more dynamic NFTs rather than solo picture
        _tokenURIs[counter] = STAR_IMAGE_IPFS_HASH;
    }

    // Function to retrieve the token URI for a given token ID and mapped to same IPFS hash
    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        string memory uri = _tokenURIs[tokenId];
        if (bytes(uri).length == 0) {
            // Handle the case where the token has no URI
            return "";
        }
        return
            string(
                abi.encodePacked("https://ipfs.io/ipfs/", _tokenURIs[tokenId])
            );
    }
}
