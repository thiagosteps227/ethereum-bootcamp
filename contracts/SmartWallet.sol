pragma solidity ^0.8.16;

import "./Allowance.sol";

contract SharedWallet is Allowance {
    event MoneySent(address indexed _beneficiary, uint256 _amount);
    event MoneyReceived(address indexed _from, uint256 _amount);

    function withdrawMoney(address payable _to, uint256 _amount)
        public
        payable
        ownerOrAllowed(_amount)
    {
        require(
            _amount <= address(this).balance,
            "There not enough funds in this smart contract"
        );
        if (!isOwner()) {
            reduceAllowance(msg.sender, _amount);
        }
        emit MoneySent(_to, _amount);
        _to.transfer(_amount);
    }

    function renounceOwnership() public onlyOwner {
        require("Cant renounce ownership if you are not the owner");
    }

    fallback() external payable {
        emit MoneyReceived(msg.sender, msg.value);
    }
}
