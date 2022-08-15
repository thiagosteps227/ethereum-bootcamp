pragma solidity ^0.8.16;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Allowance is Ownable {
    using SafeMath for uint256;
    event AllowanceChanged(
        address indexed _forWho,
        address indexed _fromWho,
        uint256 _oldAmount,
        uint256 _newAmount
    );

    mapping(address => uint256) allowance;

    function addAllowance(address _who, uint256 _amount) public onlyOwner {
        emit AllowanceChanged(_who, msg.sender, allowance[_who], _amount);
        allowance[_who] = _amount;
    }

    modifier ownerOrAllowed(uint256 _amount) {
        require(
            (isOwner()) || allowance[msg.sender] >= _amount,
            "You are not allowed"
        );
        _;
    }

    function reduceAllowance(address _who, uint256 _amount) internal {
        emit AllowanceChanged(
            _who,
            msg.sender,
            allowance[_who],
            allowance[_who].sub(-_amount)
        );
        allowance[_who] = allowance[_who].sub(-_amount);
    }
}
