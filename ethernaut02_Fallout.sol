/*
    Claim ownership of the contract below to complete this level:
    This contract is based on an old Solidity compiler (^0.6.0).
    The "constructor" is actually a public function that can be explioted by an interface.
    - create an interface:
        interface Fallout {
            function Fal1out() external  payable;
        }

    Successful submission:
    That was silly wasn't it? Real world contracts must be much more secure than this and so must it be much harder to hack them right?

    Well... Not quite.

    The story of Rubixi is a very well known case in the Ethereum ecosystem. The company changed its name from 'Dynamic Pyramid' to 'Rubixi' but somehow they didn't rename the constructor method of its contract:

    contract Rubixi {
    address private owner;
    function DynamicPyramid() { owner = msg.sender; }
    function collectAllFees() { owner.transfer(this.balance) }
    ...
    This allowed the attacker to call the old constructor and claim ownership of the contract, and steal some funds. Yep. Big mistakes can be made in smartcontractland.
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import 'openzeppelin-contracts-06/math/SafeMath.sol';

contract Fallout {
  
  using SafeMath for uint256;
  mapping (address => uint) allocations;
  address payable public owner;


  /* constructor */
  function Fal1out() public payable {
    owner = msg.sender;
    allocations[owner] = msg.value;
  }

  modifier onlyOwner {
	        require(
	            msg.sender == owner,
	            "caller is not the owner"
	        );
	        _;
	    }

  function allocate() public payable {
    allocations[msg.sender] = allocations[msg.sender].add(msg.value);
  }

  function sendAllocation(address payable allocator) public {
    require(allocations[allocator] > 0);
    allocator.transfer(allocations[allocator]);
  }

  function collectAllocations() public onlyOwner {
    msg.sender.transfer(address(this).balance);
  }

  function allocatorBalance(address allocator) public view returns (uint) {
    return allocations[allocator];
  }
}