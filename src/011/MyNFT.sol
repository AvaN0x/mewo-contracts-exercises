// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { ERC721 } from "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

// Write a sale contract that allow users to purchase NFTs.
// Maxmimum supply should be 10,000.
// Each NFT will be sold at 0.05 ether for the first 1,000 units, them 0. ether for the rest of the supply.
contract MyNFT is ERC721 {
  uint256 public constant EARLY = 0.05 ether;
  uint256 public constant NORMAL = 0.1 ether;
  uint256 public constant EARLY_SUPPLIES = 1_000;
  uint256 public constant MAXIMUM_SUPPLIES = 10_000;
  uint256 public totalSupplies;

  error InsufficientValue(uint256 expected, uint256 actual);

  constructor() ERC721("MyNFT", "MNFT") { }

  function min(uint256 a, uint256 b) internal pure returns (uint256) {
    return a < b ? a : b;
  }

  function price(uint256 quantity) internal view returns (uint256) {
    uint256 earlyQuantity = totalSupplies > EARLY_SUPPLIES ? 0 : min(quantity, EARLY_SUPPLIES);
    uint256 normalQuantity = quantity - earlyQuantity;

    return earlyQuantity * EARLY + normalQuantity * NORMAL;
  }

  function purchase(uint256 quantity) external payable {
    require(quantity > 0);
    require(totalSupplies + quantity <= MAXIMUM_SUPPLIES);
    uint256 totalPrice = price(quantity);
    if (msg.value < totalPrice) {
      revert InsufficientValue(totalPrice, msg.value);
    }

    for (uint256 i = totalSupplies; i < totalSupplies + quantity; i++) {
      _safeMint(msg.sender, i);
    }
    totalSupplies += quantity;
  }
}
