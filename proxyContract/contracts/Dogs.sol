pragma solidity 0.5.1;

import "./Storage.sol";

contract Dogs is Storage {

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor() public {
        owner = msg.sender;
    }
    
    function getNumberOfDogs() public view returns(uint256) {
        return _uintStorage["dogs"];
    }
    
    function setNumberOfDogs(uint256 _dogs) public  {
        _uintStorage["dogs"] = _dogs;
    }

}