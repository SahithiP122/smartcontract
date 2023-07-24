// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleEscrow {
    address public partyA;
    address public partyB;
    uint256 public depositAmount;
    bool public isFundsReleased;

    event FundsDeposited(address indexed depositor, uint256 amount);
    event FundsReleased(address indexed recipient, uint256 amount);

    modifier onlyPartyB() {
        require(msg.sender == partyB, "Only Party B can call this function");
        _;
    }

    modifier fundsNotReleased() {
        require(!isFundsReleased, "Funds have already been released");
        _;
    }

    constructor(address _partyB) payable {
        partyA = msg.sender;
        partyB = _partyB;
        depositAmount = msg.value;
    }

    function releaseFunds() public onlyPartyB fundsNotReleased {

        isFundsReleased = true;
        payable(partyB).transfer(depositAmount);
        emit FundsReleased(partyB, depositAmount);
    }

    function getDepositAmount() public view returns (uint256) {
        return depositAmount;
    }
}
