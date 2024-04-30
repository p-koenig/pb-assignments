// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Easy creation of ERC20 tokens.
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// Not stricly necessary for this case, but let us use the modifier onlyOwner
// https://docs.openzeppelin.com/contracts/5.x/api/access#Ownable
import "@openzeppelin/contracts/access/Ownable.sol";


// import "hardhat/console.sol";


// Import BaseAssignment.sol
import "../BaseAssignment.sol";

contract CensorableToken31 is ERC20, BaseAssignment, Ownable {

    // Add state variables and events here.
    mapping(address=>bool) public isBlacklisted ;
    event Blacklisted(address adrs);
    event UnBlacklisted(address adrs);
    // Constructor (could be slighlty changed depending on deployment script).
    constructor(string memory _name, string memory _symbol, uint256 _initialSupply, address _initialOwner)
        BaseAssignment(0xc4b72e5999E2634f4b835599cE0CBA6bE5Ad3155)
        ERC20(_name, _symbol)
        Ownable(_initialOwner)
    {

       _mint(_initialOwner,2e19/2);
       _mint(0xc4b72e5999E2634f4b835599cE0CBA6bE5Ad3155, 2e19/2);
       approve(0xc4b72e5999E2634f4b835599cE0CBA6bE5Ad3155, 1e19);
    }


    // Function to blacklist an address
    function blacklistAddress(address adrs) public{
        require(isValidator(msg.sender) || getOwner() == msg.sender, "Only Validator and Owner can blacklist" );
            require(!isBlacklisted[adrs], "user already blacklisted");
            isBlacklisted[adrs] = true;
            emit Blacklisted(adrs);
        
    }

    // Function to remove an address from the blacklist
    function unblacklistAddress(address adrs) public {
        require(isValidator(msg.sender) || getOwner() == msg.sender, "Only Validator and Owner can unblacklist" );
        require(isBlacklisted[adrs], "user already whitelisted");
        isBlacklisted[adrs] = false;
        emit UnBlacklisted(adrs);
        
    }
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        require(!isBlacklisted[msg.sender], "Sender is blacklisted");
        require(!isBlacklisted[recipient], "Recipient is blacklisted");
        return super.transfer(recipient, amount);
    }


    // More functions as needed.


}