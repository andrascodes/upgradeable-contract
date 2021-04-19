pragma solidity 0.5.1;


contract Bank {

    mapping(address => uint) balances;
    address public owner;
    bool private _paused;

    constructor () internal {
        unpause();
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    // Allow to execute when contract is not paused
    modifier whenNotPaused() {
        require(_paused == false);
        _;
    }
    
    modifier whenPaused() {
        require(_paused == true);
        _;
    }

    function pause() public onlyOwner whenNotPaused {
        _paused = true;
    }

    function unpause() public onlyOwner whenPaused {
        _paused = false;
    }

    function withdrawAll() public whenNotPaused {
        uint amountToWithdraw = balances[msg.sender];
        balances[msg.sender] = 0;
        require(msg.sender.call.value(amountToWithdraw));
    }

    function emergencyWithdrawal(address emergencyAddress) public onlyOwner whenPaused {
        // withdrawal to owner
    }

}