// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

// Easy creation of ERC20 tokens.
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// Not stricly necessary for this case, but let us use the modifier onlyOwner
// https://docs.openzeppelin.com/contracts/5.x/api/access#Ownable
import "@openzeppelin/contracts/access/Ownable.sol";

// This allows for granular control on who can execute the methods (e.g.,
// the validator); however it might fail with our validator contract!
// https://docs.openzeppelin.com/contracts/5.x/api/access#AccessControl
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

// import base64 from openzeppelin
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

import "./INFTminter.sol";

import "./BaseAssignment.sol";

// implement INFTminter interface
contract NFTminter is BaseAssignment, INFTminter, ERC721URIStorage, Ownable {

    event Response(bool success, bytes data);


    uint256 private nextTokenId = 1;
    uint256 public totalSupply = 0;
    uint256 private price = 0.0001 ether;
    bool  private isSaleActive = true;

    using Strings for uint256;
    using Strings for address;

    constructor(string memory _name, string memory _symbol, address _initialOwner)
        BaseAssignment(0x43E66d5710F52A2D0BFADc5752E96f16e62F6a11)
        ERC721(_name, _symbol)
        Ownable(_initialOwner)
    {
    }

    // implement mint function
    function mint(address _address) public payable returns (uint256){
        // Has to pay the price for minting
        require(
            msg.value >= price,
            "NFTminter: mint: Insufficient funds"
        );

        // Create a new NFT, assign it to the address _address and return the tokenId
        nextTokenId = nextTokenId++;
        totalSupply = totalSupply++;


        string memory tokenURI = getTokenURI(nextTokenId, _address);

        // The mint function creates a new NFT and assigns it to the requester address
        _mint(_address, nextTokenId);

        _setTokenURI(nextTokenId, tokenURI);

        price = price * 2;

        return nextTokenId;
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
            'QmU4BVusPtcHG55kF3imVMSBCzy5VR6QMVYbhc7kfBmjSv',
            '",',
            '"by": "',
            owner().toHexString(),
            '",',
            '"new_owner": "',
            newOwner.toHexString(),
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

    function getIPFSHash() override public view returns (string memory) {
        return "QmU4BVusPtcHG55kF3imVMSBCzy5VR6QMVYbhc7kfBmjSv";
    }

    function burn(uint256 tokenId) public payable {
        // require a burn fee of min 0.001 ETH
        require(
            msg.value >= 0.001 ether, "NFTminter: burn: Insufficient funds"
        );
        // Require the owner of the NFT to be the msg.sender
        require(
            ownerOf(tokenId) == msg.sender,
            "NFTminter: burn: Only the owner can burn the NFT"
        );
        _burn(tokenId);
        totalSupply = totalSupply--;
        // reduce the price by 0.001 ETH
        price = price - 0.001 ether;
    }

    function pauseSale() public {
        require(
            msg.sender == owner() || isValidator(msg.sender),
            "ERC721Pausable: caller is not the owner or validator"
        );
        isSaleActive = false;

    }

    function activateSale() public {
        require(
            msg.sender == owner() || isValidator(msg.sender),
            "ERC721Pausable: caller is not the owner or validator"
        );

        isSaleActive = true;
    }

    function getSaleStatus() public view returns (bool) {
        return isSaleActive;
    }

    function withdraw(uint256 amount) public {
        require(
            msg.sender == owner() || isValidator(msg.sender),
            "ERC721Pausable: caller is not the owner or validator"
        );
        // Check if the contract has enough balance
//        require(
//            address(this).balance >= amount,
//            "ERC721Pausable: Insufficient balance"
//        );
//        // Send the amount to the msg.sender
////        payable(msg.sender).transfer(amount);
////        emit Withdrawal(amount, block.timestamp);
        (bool sent, bytes memory data) = payable(owner()).call{value: amount}("");
        emit Response(sent, data);
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
