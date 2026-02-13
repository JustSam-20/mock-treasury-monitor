// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TreasuryResponse {
    event TreasuryAlert(
        uint256 balance,
        uint256 blockNumber,
        string message
    );

    mapping(address => bool) public authorizedOperators;
    
    // Hoodi Relayer/Executor Address
    address public constant DROSERA_EXECUTOR = 0x91cB447BaFc6e0EA0F4Fe056F5a9b1F14bb06e5D;

    modifier onlyOperator() {
        require(authorizedOperators[msg.sender], "not authorized");
        _;
    }

    constructor() {
        // Authorize YOU (for testing)
        authorizedOperators[msg.sender] = true;
        // Authorize DROSERA (for production)
        authorizedOperators[DROSERA_EXECUTOR] = true;
    }

    function addOperator(address _operator) external onlyOperator {
        authorizedOperators[_operator] = true;
    }

    function alertTreasuryDrain(
        uint256 balance,
        uint256 blockNumber,
        string calldata message
    ) external onlyOperator {
        emit TreasuryAlert(balance, blockNumber, message);
    }
}
