// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

interface IERC20 {

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);


    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

 contract AutoToken is IERC20 { 

  mapping(address => uint256) public balanceOf;
  mapping(address => mapping(address => uint256)) public allowance;
  string public name = "TestTokenDex";
  string public symbol = "ATT";
  uint256 public totalSupply;

  constructor(uint256 _totalSupply){ 
    totalSupply = _totalSupply;
    balanceOf[msg.sender] = _totalSupply;
  }

  function transfer(address recipient, uint256 amount) external returns (bool){ 

    require(balanceOf[msg.sender] >= amount, 'balance of sender is below amount');
    require(totalSupply >= amount, 'total supply is lesser than amount');

    balanceOf[msg.sender] -= amount;    
    balanceOf[recipient] += amount;

    emit Transfer(msg.sender, recipient, amount);

    return true;
  }

  function approve(address spender, uint256 amount) external returns (bool){ 

    require(balanceOf[msg.sender] >= amount, 'balance of sender is below amount');
    allowance[msg.sender][spender] = amount;


    emit Approval(msg.sender, spender, amount);
    return true;
  }

  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool){

    require(balanceOf[sender] >= amount, 'balance of sender is below amount');
    require(allowance[sender][msg.sender] >= amount, 'allowance is lesser than amount');

    balanceOf[recipient] += amount;
    balanceOf[sender] -= amount;

    allowance[sender][msg.sender] -= amount;

    emit Transfer(sender, recipient, amount);
    return true;
  }


}