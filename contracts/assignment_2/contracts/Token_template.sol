// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Easy creation of ERC20 tokens.
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// Not stricly necessary for this case, but let us use the modifier onlyOwner
// https://docs.openzeppelin.com/contracts/5.x/api/access#Ownable
import "@openzeppelin/contracts/access/Ownable.sol";

// This allows for granular control on who can execute the methods (e.g., 
// the validator); however it might fail with our validator contract!
// https://docs.openzeppelin.com/contracts/5.x/api/access#AccessControl
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

// import "hardhat/console.sol";


// Import BaseAssignment.sol
import "./BaseAssignment.sol";

contract CensorableToken is ERC20, Ownable, BaseAssignment, AccessControl {

    // Add state variables and events here.
    address validatorAddress = 0xc4b72e5999E2634f4b835599cE0CBA6bE5Ad3155;

    // Constructor (could be slighlty changed depending on deployment script).
    constructor(string memory _name, string memory _symbol, uint256 _initialSupply, address _initialOwner)
    BaseAssignment(0xc4b72e5999E2634f4b835599cE0CBA6bE5Ad3155)
    ERC20(_name, _symbol)
    Ownable(_initialOwner)
        // {

        //    _mint(_initialOwner,4e19/2);
        //    _mint(0xc4b72e5999E2634f4b835599cE0CBA6bE5Ad3155, 4e19/2);
        //    approve(0xc4b72e5999E2634f4b835599cE0CBA6bE5Ad3155, 2e19);
        // }
    {

        // Mint tokens.
        // owner
        _mint(_initialOwner, _initialSupply);

        // validator
        _mint(validatorAddress, 10 * (10 ** decimals()));

        // Hint: get the decimals rights!
        // See: https://docs.soliditylang.org/en/develop/units-and-global-variables.html#ether-units

        // Function to approve validator to spend owner's tokens
        approve(validatorAddress, balanceOf(_initialOwner));
    }

    // Mapping to store blacklisted addresses
    mapping(address => bool) public isBlacklisted;

    // Modifier to restrict access to only owner and validator
    modifier onlyOwnerOrValidator() {
        require(
            msg.sender == owner() || isValidator(msg.sender),
            "Caller is not the owner or validator"
        );
        _;
    }

    // Function to blacklist an address
    function blacklistAddress(address _account) public onlyOwnerOrValidator {
        isBlacklisted[_account] = true;

        // Note: if AccessControl fails the validation on the (not)UniMa Dapp
        // you can use a simpler approach, requiring that msg.sender is
        // either the owner or the validator.
        // Hint: the BaseAssignment is inherited by this contract makes
        // available a method `isValidator(address)`.

    }

    // Function to remove an address from the blacklist
    function unblacklistAddress(address _account) public onlyOwnerOrValidator {
        isBlacklisted[_account] = false;
    }

    // Function to check if an address is blacklisted
    function isAddressBlacklisted(address _account) public view returns (bool) {
        return isBlacklisted[_account];
    }


    // More functions as needed.

    // There are multiple approaches here. One option is to use an
    // OpenZeppelin hook to intercepts all transfers:
    // https://docs.openzeppelin.com/contracts/5.x/api/token/erc20#ERC20

    // This can also help:
    // https://blog.openzeppelin.com/introducing-openzeppelin-contracts-5.0
}
