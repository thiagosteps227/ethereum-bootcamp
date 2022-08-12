pragma solidity ^0.8.16;

import "@openzeppelin/contracts/access/Ownable.sol";

contract SharedWallet is Ownable {
    mapping(address => uint256) allowance;

    function addAllowance(address _who, uint256 _amount) public onlyOwner {
        allowance[_who] = _amount;
    }

    modifier ownerOrAllowed(uint256 _amount) {
        require(
            isOwner() || allowance[msg.sender] >= _amount,
            "You are not allowed"
        );
        _;
    }

    function withdrawMoney(address payable _to, uint256 _amount)
        public
        payable
        ownerOrAllowed(_amount)
    {
        _to.transfer(_amount);
    }

    receive() external payable {}
}
