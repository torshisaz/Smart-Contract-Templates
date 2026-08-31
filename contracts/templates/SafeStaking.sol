// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/// @title SafeStaking - Staking with reentrancy protection
contract SafeStaking is ReentrancyGuard {
    IERC20 public stakingToken;
    mapping(address => uint256) public staked;
    mapping(address => uint256) public lastStakeTime;
    
    uint256 public minStakeDuration = 1 days;
    uint256 public totalStaked;
    
    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    
    constructor(address _stakingToken) {
        stakingToken = IERCC20(_stakingToken);
    }
    
    function stake(uint256 amount) external nonReentrant {
        require(amount > 0, "Zero amount");
        stakingToken.transferFrom(msg.sender, address(this), amount);
        staked[msg.sender] += amount;
        lastStakeTime[msg.sender] = block.timestamp;
        totalStaked += amount;
        emit Staked(msg.sender, amount);
    }
    
    function withdraw(uint256 amount) external nonReentrant {
        require(staked[msg.sender] >= amount, "Insufficient");
        require(block.timestamp >= lastStakeTime[msg.sender] + minStakeDuration, "Lock period");
        staked[msg.sender] -= amount;
        totalStaked -= amount;
        stakingToken.transfer(msg.sender, amount);
        emit Withdrawn(msg.sender, amount);
    }
    
    function setMinStakeDuration(uint256 duration) external {
        minStakeDuration = duration;
    }
}
