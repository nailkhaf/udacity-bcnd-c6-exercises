pragma solidity ^0.5.0;

/**
 * The Withdraw contract does this and that...
 */
contract Withdraw {

    using SafeMath for uint256;

    uint256 private entrancyCounter = 1;

    mapping(address => uint256) private sales;
    uint256 private enabled = block.timestamp;

    modifier rateLimit(uint time) {
        require (block.timestamp >= time, "Not passed rateLimit");
        enabled = enabled.add(time);
        _;
    }

    modifier entrancyGuard() {
        entrancyCounter = entrancyCounter.add(1);
        uint256 _entrancyCounter = entrancyCounter;
        _;
        require(entrancyCounter == _entrancyCounter, "entrancy guard error")
    }


    function safeWithdraw (uint256 amount) external rateLimit(30 minutes) entrancyGuard() {
        // Checks
        require(msg.sender == tx.origin, "contracts ate not allowed")
        require(sales[msg.sender] >= amount, "caller account ask too big money");
        // Effects
        uint256 balance = sales[msg.sender];
        sales[msg.sender] = balance.sub(amount);
        // Interaction
        msg.sender.transfer(amount);
    }
}
