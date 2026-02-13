// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "drosera-contracts/interfaces/ITrap.sol";
import "openzeppelin-contracts/token/ERC20/IERC20.sol";

contract TreasuryTrap is ITrap {
    // Corrected Checksum: 0x33C...Bea4
    address public constant TARGET_TOKEN = 0x33C934B97bE8fc22683Ab235F5cb35c355e8Bea4;
    
    // Corrected Checksum: 0xCF7...AE59 (Matches your error message exactly)
    address public constant TREASURY_WALLET = 0xCF75BEA7A11eB8a764dC85DEf2F36C3ed826AE59;
    
    uint256 public constant MIN_BALANCE = 500_000 * 10**18; 

    function collect() external view override returns (bytes memory) {
        if (TARGET_TOKEN.code.length == 0) return bytes("");
        try IERC20(TARGET_TOKEN).balanceOf(TREASURY_WALLET) returns (uint256 currentBalance) {
            return abi.encode(currentBalance, block.number);
        } catch {
            return bytes("");
        }
    }

    function shouldRespond(bytes[] calldata data) 
        external 
        pure 
        override 
        returns (bool, bytes memory) 
    {
        if (data.length == 0 || data[0].length != 64) return (false, bytes(""));

        (uint256 currentBalance, uint256 blockNumber) = abi.decode(data[0], (uint256, uint256));

        if (currentBalance < MIN_BALANCE) {
            return (true, abi.encode(
                currentBalance,
                blockNumber,
                "Treasury Drain Detected!"
            ));
        }

        return (false, bytes(""));
    }
}
