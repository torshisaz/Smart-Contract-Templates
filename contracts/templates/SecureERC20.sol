// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title SecureERC20 - ERC20 with common security patterns
contract SecureERC20 is ERC20, Ownable {
    mapping(address => bool) public blacklisted;
    uint256 public maxTxAmount;
    bool public tradingEnabled = true;
    
    event Blacklisted(address indexed account, bool status);
    event MaxTxAmountUpdated(uint256 newAmount);
    
    constructor(
        string memory name,
        string memory symbol,
        uint256 initialSupply
    ) ERC20(name, symbol) Ownable(msg.sender) {
        maxTxAmount = (initialSupply * 2) / 100; // 2% default
        _mint(msg.sender, initialSupply);
    }
    
    modifier whenTradingEnabled() {
        require(tradingEnabled, "Trading disabled");
        _;
    }
    
    modifier notBlacklisted(address account) {
        require(!blacklisted[account], "Blacklisted");
        _;
    }
    
    function transfer(address to, uint256 amount) public override notBlacklisted(msg.sender) notBlacklisted(to) whenTradingEnabled returns (bool) {
        require(amount <= maxTxAmount, "Exceeds max tx");
        return super.transfer(to, amount);
    }
    
    function transferFrom(address from, address to, uint256 amount) public override notBlacklisted(from) notBlacklisted(to) whenTradingEnabled returns (bool) {
        require(amount <= maxTxAmount, "Exceeds max tx");
        return super.transferFrom(from, to, amount);
    }
    
    function blacklist(address account, bool status) external onlyOwner {
        blacklisted[account] = status;
        emit Blacklisted(account, status);
    }
    
    function setMaxTxAmount(uint256 amount) external onlyOwner {
        maxTxAmount = amount;
        emit MaxTxAmountUpdated(amount);
    }
    
    function setTradingEnabled(bool enabled) external onlyOwner {
        tradingEnabled = enabled;
    }
    
    function emergencyWithdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
