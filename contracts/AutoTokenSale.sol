// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.17;
import "./AutoToken.sol";


 contract AutoTokenSale { 
  AutoToken public tokenContract; 
  uint256 public tokenBuyingPrice;
  uint256 public tokenSellingPrice;
  address internal admin;
  uint256 public totalATDSold; 
  uint256 public totalATDBought;

  uint public numberOfExecutedSold;
  uint public numberOfExecutedBought;

  event Sell(address buyer, uint256 token);
  event Buy(address seller, uint256 token);

  constructor(AutoToken _tokenContract, uint256 _tokenBuyingPrice, uint256 _tokenSellingPrice){ 
    tokenContract = _tokenContract;
    tokenBuyingPrice = _tokenBuyingPrice;
    tokenSellingPrice = _tokenSellingPrice;
    admin = msg.sender;// ensure the creator of the contract is the admin
    // tokenContract.transfer(address(this), tokenContract.totalSupply());// assign all tokens to the sale contract

    totalATDBought = 0;
    totalATDSold = 0;
    numberOfExecutedBought = 0;
    numberOfExecutedSold = 0;
  }

  function multiply(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x);
  }

  function buyToken(uint256 _numberOfTokens) public payable returns (bool) { // user wants to buy

    uint256 cost = multiply(_numberOfTokens, tokenBuyingPrice);

    require( cost == msg.value, 'the cost must be equal to the eth amount');
    require(tokenContract.balanceOf(address(this)) >= _numberOfTokens, 'token sale contract needs to be funded'); // ensure the contract has enough balance

    require(tokenContract.transfer(msg.sender, _numberOfTokens),'transaction did not go through'); // send them their token

    emit Sell(msg.sender, _numberOfTokens);

    totalATDBought += _numberOfTokens;
    numberOfExecutedBought += 1;

    return true;
  }

  function sellToken(uint256 _numberOfTokens) public returns (bool) { // user wants to sell
    uint256 profit = multiply(_numberOfTokens, tokenSellingPrice);

    // bool approved = tokenContract.approve(address(this), _numberOfTokens);

    // require(approved, 'transaction could not be approved');
    uint256 allowance = tokenContract.allowance(msg.sender, address(this)); // collect allowance to spend on behalf of the seller
  
    require(allowance >= _numberOfTokens, "Check the token allowance");
  
    tokenContract.transferFrom(msg.sender, address(this), _numberOfTokens);

    
    (bool sent, bytes memory data) = msg.sender.call{value: profit}(""); // send the caller eth

    data;
    require(sent, 'Failed to credit customer');

    emit Buy(msg.sender, _numberOfTokens);

    totalATDSold += _numberOfTokens;
    numberOfExecutedSold += 1;

    return true;
  }

  function totalEthereumReceived() public view returns (uint256){ 
      return multiply(totalATDBought, tokenBuyingPrice);
  }

  function totalEthereumSent() public view returns (uint256){ 
      return multiply(totalATDSold, tokenSellingPrice);
  }

}