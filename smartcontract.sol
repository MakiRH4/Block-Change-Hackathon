 // SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

contract DebtContract {

    struct Debt {
        uint32  quantity;
        uint32  rate;
    }

    struct Bond {
        address ownerAddress;
        uint32  quantity;
        uint32  rate;
        uint256 emissionDate;
        uint256 expiryDate;
        bool    isFinished;
    }

    uint32 pool;

    mapping(address => Debt) debts;

    function createDebt(address studentAddress, uint32 quantity, uint32 debtRate) public {
      
        require(quantity <= (pool * 5) / 100, "Quantity exceeds 5% of the pool");
        pool -= quantity;
        Debt memory newDebt;
        newDebt.quantity = quantity * debtRate;
        newDebt.rate = debtRate;
        debts[studentAddress] = newDebt;
    }

    function payDebt(address studentAddress, uint32 payment) public {
        require(debts[studentAddress].quantity >= payment, "Payment amount exceeds debt quantity");
        debts[studentAddress].quantity -= payment;
    }

    mapping(address => Bond) bonds;

    function createBond(address ownerAddress, uint32 quantity, uint32 bondRate, uint256 expDate) public {
      
        Bond memory newBond;
        newBond.quantity = quantity * bondRate;
        newBond.rate = bondRate;
        newBond.emissionDate = block.timestamp;
        newBond.expiryDate = expDate;
        newBond.isFinished = false;
        bonds[ownerAddress] = newBond;
        pool += quantity;
    }

    function claimBond(address ownerAddress) public {
        require(block.timestamp > bonds[ownerAddress].expiryDate, "Payment date not reached");
        bonds[ownerAddress].isFinished = true;
        pool -= bonds[ownerAddress].quantity;
        
    }
}