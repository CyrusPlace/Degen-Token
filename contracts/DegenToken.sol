// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DegenToken is ERC20 {
address gameOwner;
uint256  tokenPrice;
uint256  healthCost;
uint256  skinCost;
uint256  emblemCost; 
uint256 gemCost;

mapping (address => mapping (string => uint256)) public playerInventory;

constructor() ERC20("DegenToken", "DGN") {
gameOwner = msg.sender;
tokenPrice = 50;
healthCost = 20;
skinCost = 1;
emblemCost = 5;
gemCost = 2;
}

modifier onlyOwners() {
require(msg.sender == gameOwner, "you are not the owner");
_;
}

function mintDegenToken(address _player, uint256 _amount) public virtual onlyOwners {
_mint(_player, _amount);
}

function burnDegenToken(uint256 amount) public {
_burn(msg.sender, amount);
}

function transferDegenToken(address to, uint256 amount) public {
_transfer(msg.sender, to, amount);
}

function buyToken() public payable {
uint256 amount = msg.value / tokenPrice;
_mint(msg.sender, amount);
}

function getTokenBalance(address player) public view returns (uint256) {
return balanceOf(player);
}

function showStore() external pure returns (string memory) {
return "Health, Skin, Emblems, Gems";
}

function redeemItem(string calldata _item, uint256 quantity) public payable {
if (keccak256(abi.encodePacked(_item)) == keccak256(abi.encodePacked("Health"))) {
require(balanceOf(msg.sender) >= healthCost * quantity, "Not enough Degen Tokens to buy health");
_transfer(msg.sender, address(this), healthCost * quantity);
playerInventory[msg.sender]["Health"] += quantity; // deliver health to player
} else if (keccak256(abi.encodePacked(_item)) == keccak256(abi.encodePacked("Skin"))) {
require(balanceOf(msg.sender) >= skinCost * quantity, "Not enough Degen Tokens to buy skin");
_transfer(msg.sender, address(this), skinCost * quantity);
playerInventory[msg.sender]["Skin"] += quantity; // deliver skin to player
} else if (keccak256(abi.encodePacked(_item)) == keccak256(abi.encodePacked("Emblem"))) {
require(balanceOf(msg.sender) >= emblemCost * quantity, "Not enough Degen Tokens to buy emblem");
_transfer(msg.sender, address(this), emblemCost * quantity);
playerInventory[msg.sender]["Emblem"] += quantity; // deliver emblem to player
} else if (keccak256(abi.encodePacked(_item)) == keccak256(abi.encodePacked("Gems"))) {
require(balanceOf(msg.sender) >= gemCost * quantity, "Not enough Degen Tokens to buy gems");
_transfer(msg.sender, address(this), gemCost * quantity);
playerInventory[msg.sender]["Gems"] += quantity; // deliver gems to player
} else {
revert("Invalid item");
}
}
}