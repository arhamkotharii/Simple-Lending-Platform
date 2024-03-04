// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Importing ERC20 interface for handling funds
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MyLendingDepositingPlatform {
    address public owner;
    IERC20 public token; // Using ERC-20 token for handling funds

    mapping(address => uint256) public accountToBalance;  // mapping any user address to its available balance
    mapping(address => uint256) public accounttoBorrowedAmount; // mapping user address to amount borrowed

    event Deposit(address indexed user, uint256 amount);
    event Withdrawal(address indexed user, uint256 amount);
    event Borrow(address indexed user, uint256 amount);
    event Repay(address indexed user, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Sirf Malik ko paisa milega");
        _;
    }

    constructor(address _tokenAddress) {
        owner = msg.sender;  // i have assigned the sender of this contract as the owner rightfull to withdraw funds .
        token = IERC20(_tokenAddress);
    }

    // Below function is used to deposit ETH into the contract // external function allowing access to all
    function deposit(uint256 amount) external {
        require(amount > 0, "funds transferred can not be non positive");

        // Transfer tokens from user to the contract
        token.transferFrom(msg.sender, address(this), amount);

        // Updating the user balance
        accountToBalance[msg.sender] += amount;

        emit Deposit(msg.sender, amount);
    }

    // Withdraw Eth from the lending platform
    function withdraw(uint256 amount) external {
        require(amount > 0, "Withdrawal amount must be greater than zero");
        require(amount <= accountToBalance[msg.sender], "Insufficient balance hai bhai");

        // Update user balance
        accountToBalance[msg.sender] -= amount;

        // Transfer tokens from contract to the user
        token.transfer(msg.sender, amount);

        emit Withdrawal(msg.sender, amount);
    }

    // Borrow Ethereum from the lending platform
    function borrow(uint256 amount) external {
        require(amount > 0, "Borrow amount must be greater than zero");
        require(amount <= (accountToBalance[msg.sender] * 2), "Cannot borrow more than twice the deposit(standard rule)");

        // Update user borrowed amount
        accounttoBorrowedAmount[msg.sender] += amount;

        // Transfer tokens from contract to the user
        token.transfer(msg.sender, amount);

        emit Borrow(msg.sender, amount);
    }

    // udhari ki ether wapas chukaane ka function
    function repay(uint256 amount) external {
        require(amount > 0, "Repay amount must be greater than zero");
        require(amount <= accounttoBorrowedAmount[msg.sender], "Cannot repay more than borrowed");

        // Update user borrowed amount
        accounttoBorrowedAmount[msg.sender] -= amount;

        // Transfer tokens from user to the contract
        token.transferFrom(msg.sender, address(this), amount);

        emit Repay(msg.sender, amount);
    }

    // Check user balance
    function checkBalance() external view returns (uint256) {
        return accountToBalance[msg.sender];
    }

    // Couldnt immplenent interest rates,sorry 
}
