// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TestNFT is ERC721Enumerable, Ownable {
    using Strings
    for uint256;

    string public baseURI; 
    string public baseExtension = ".json";
    uint256 public maxSupply = 10000; // 발행량
    uint256 public maxMintAmount = 10; // 한번의 계약에 맥스 구매량
    bool public paused = false;
    mapping(address => bool) public whitelisted;

    // 토큰 네임과 스마트 계약
    constructor(
        string memory _initBaseURI
    ) ERC721("SABUsNFT", "SABU") {
        setBaseURI(_initBaseURI);
    }

    //URI
    function _baseURI() internal view virtual override returns(string memory) {
        return baseURI;
    }

    // 계약된 오너 지갑에게만 전송
    function TransForOwner(uint256 _mintAmount) public onlyOwner{
        uint256 supply = totalSupply();
        require(!paused);
        require(_mintAmount > 0);
        require(_mintAmount <= 100);
        require(supply + _mintAmount <= maxSupply);

        for (uint256 i = 1; i <= _mintAmount; i++) {
            _safeMint(msg.sender, supply + i);
        }
    }
    function tokenURI(uint256 tokenId)
    public
    view
    virtual
    override
    returns(string memory) {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        string memory currentBaseURI = _baseURI();
        return bytes(currentBaseURI).length > 0 ?
            string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension)) :
            "";
    }
    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }
    function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
        baseExtension = _newBaseExtension;
    }

    function pause(bool _state) public onlyOwner {
        paused = _state;
    }
}