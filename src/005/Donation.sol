// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Write a contract that allow users to donate ether.abi
// - Only the account that deployed the contract is allowed to withdraw the funds via a `withdraw` function.
// - User will be able to donate ether to the contract via `donate`. Zero donation should be rjected.
// - Expose a `donated(address who)` function that allow to check how much an address has donated.
contract Donation {
  address internal owner;
  mapping(address => uint256) private donations;

  constructor() {
    owner = msg.sender;
  }

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  function donate() public payable {
    require(msg.value > 0);
    donations[msg.sender] += msg.value;
  }

  function donated(address who) public view returns (uint256) {
    return donations[who];
  }

  function withdraw() public onlyOwner {
    payable(owner).transfer(address(this).balance);
  }
}
