// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./RewardToken.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract RewardManager is Ownable {
    IERC20 private  immutable rewardToken;
    uint256 public rewardAmount;

    event RewardRedeemed(address indexed user, uint256 amount);

    constructor(address tokenAddress, uint256 _rewardAmount) Ownable(msg.sender) {
        rewardToken = IERC20(tokenAddress);
        rewardAmount = _rewardAmount * 10**18; // Set reward amount with decimals
    }

    function setRewardAmount(uint256 _rewardAmount) external onlyOwner {
        rewardAmount = _rewardAmount * 10**18;
    }

    function redeem() external {
        require(rewardToken.balanceOf(address(this)) >= rewardAmount, "Insufficient reward token balance in contract");

        rewardToken.transfer(msg.sender, rewardAmount);

        emit RewardRedeemed(msg.sender, rewardAmount);
    }

    function fundContract(uint256 amount) external onlyOwner {
        // Ensure the owner has approved the transfer of tokens before calling this function
        require(rewardToken.transferFrom(msg.sender, address(this), amount * 10**18), "Funding contract failed");
    }

    function transferGreenTokens(uint amount) external returns(bool) {
        rewardToken.transfer(msg.sender, amount * (10**18));
        return true;
    }
}