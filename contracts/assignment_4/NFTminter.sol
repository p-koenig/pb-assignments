// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

// Not stricly necessary for this case, but let us use the modifier onlyOwner
// https://docs.openzeppelin.com/contracts/5.x/api/access#Ownable
//import "@openzeppelin/contracts/access/Ownable.sol";

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


import "./INFTminter.sol";

import "./BaseAssignment.sol";

// implement INFTminter interface
contract NFTminter is BaseAssignment, INFTminter, ERC721URIStorage { // Ownable

//    event Response(bool success, bytes data);

    using Strings for uint256;
    using Strings for address;

    uint256 private nextTokenId = 0;
    uint256 totalSupply = 0;
    uint256 price = 0.0001 ether;
    bool private isSaleActive = true;



    constructor(string memory _name, string memory _symbol, address _initialOwner)
        ERC721(_name, _symbol)
        BaseAssignment(0x43E66d5710F52A2D0BFADc5752E96f16e62F6a11)

//        Ownable(_initialOwner)
    {
    }

    // implement mint function
    function mint(address _address) external payable returns (uint256){
        // Has to pay the price for minting
        require(isSaleActive, "Sale is not active");
        require(
            msg.value >= price,
            "NFTminter: mint: Insufficient funds"
        );

        uint256 tokenId = nextTokenId++;


        // Create a new NFT, assign it to the address _address and return the tokenId
        totalSupply++;


        string memory tokenURI = getTokenURI(tokenId, _address);

        // The mint function creates a new NFT and assigns it to the requester address
        _mint(_address, tokenId);

        _setTokenURI(tokenId, tokenURI);

        price = price * 2;

        return tokenId;
    }

    function getTokenURI(uint256 tokenId, address newOwner)
        public
        view
        returns (string memory){

        bytes memory dataURI = abi.encodePacked(
            "{",
            '"name": "My beautiful artwork #',
            tokenId.toString(),
            '"',
            '"hash": "',
            this.getIPFSHash(),
            '",',
            '"by": "',
            getOwner(),
            '",',
            '"new_owner": "',
            newOwner,
            '"',
            "}"
        );

        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(dataURI)
                )
            );
    }

    function getIPFSHash() public view returns (string memory) {
        return "QmU4BVusPtcHG55kF3imVMSBCzy5VR6QMVYbhc7kfBmjSv";
    }

    function burn(uint256 tokenId) external payable {
        // require a burn fee of min 0.001 ETH
        require(
            msg.value >= 0.0001 ether, "NFTminter: burn: Insufficient funds"
        );
        // Require the owner of the NFT to be the msg.sender
        require(
            ownerOf(tokenId) == msg.sender,
            "NFTminter: burn: Only the owner can burn the NFT"
        );
        _burn(tokenId);
        totalSupply--;
        // reduce the price by 0.001 ETH
        price = 0.0001 ether;
    }

    function pauseSale() public {
        require(
            msg.sender == 0x80400f9307e649Ba1dF9823074C5F492676B8430 || isValidator(msg.sender),
            "ERC721Pausable: caller is not the owner or validator"
        );
        isSaleActive = false;

    }

    function activateSale() public {
        require(
            msg.sender == 0x80400f9307e649Ba1dF9823074C5F492676B8430 || isValidator(msg.sender),
            "ERC721Pausable: caller is not the owner or validator"
        );

        isSaleActive = true;
    }

    function getSaleStatus() public view returns (bool) {
        return isSaleActive;
    }

    function withdraw(uint256 amount) public {
        require(
            msg.sender == 0x80400f9307e649Ba1dF9823074C5F492676B8430 || isValidator(msg.sender),
            "ERC721Pausable: caller is not the owner or validator"
        );
        require(address(this).balance >= amount, "NFT: Insufficient balance");
        msg.sender.call{gas: 10_000, value: amount}("");
//        emit Response(sent, data);
//        require(sent, "Failed to send Ether");
    }

    function getPrice() public view returns (uint256) {
        // Return the current price
        return price;
    }

    function getTotalSupply() public view returns (uint256) {
        // Return the total supply
        return totalSupply;
    }

}
