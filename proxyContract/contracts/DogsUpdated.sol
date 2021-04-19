pragma solidity 0.5.1;

import "./Storage.sol";

contract DogsUpdated is Storage {

    // we can never have any state variables in our functional contracts apart from what's in Storage
    // if we'd have one, then that variable would be attempted to be written in Proxy's scope
    // but that wouldn't exist in Proxy's scope

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor() public {
        // without calling this once here in DogsUpdated
        // initialize in DogsUpdated's context would have been false
        initialize(msg.sender);
    }

    // could set more init variables too other than just owner
    // useful when there's a more elaborate start state
    // proxy can call it and set its state
    // delegatecall into intialize, to set up the initial state in the proxy scope
    function initialize(address _owner) public {
        // only run once
        require(_initialized == false);
        owner = _owner;
        _initialized = true;
    }
    
    function getNumberOfDogs() public view returns(uint256) {
        return _uintStorage["dogs"];
    }
    
    function setNumberOfDogs(uint256 _dogs) public onlyOwner {
        _uintStorage["dogs"] = _dogs;
    }

}