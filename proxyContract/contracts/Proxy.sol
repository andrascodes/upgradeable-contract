pragma solidity 0.5.1;

import "./Storage.sol";

contract Proxy is Storage {

    address currentAddress;

    constructor(address _currentAddress) public {
        currentAddress = _currentAddress;
    }

    function upgrade(address _newAddress) public {
        currentAddress = _newAddress;
    }

    // fallback function
    // if the called function on the contract doesn't exist, then the fallback function will be executed
    // takes every function call that comes
    function () payable external {
        // redirect to currentAddress

        address implementation = currentAddress;
        require(currentAddress != address(0));
        bytes memory data = msg.data;

        assembly {
            // this delegatecall uses Proxy's state context to execute, meaning it changes the state vars here
            // every variable setting will get saved here
            // also it will try to read variable data from Proxy's storage, instead of Dogs
            // for onlyOwner it will check against owner in Proxy, which is not set by default
            let result := delegatecall(gas, implementation, add(data, 0x20), mload(data), 0, 0)
            let size := returndatasize
            let ptr := mload(0x40)
            returndatacopy(ptr, 0, size)
            // if, case 0 (delegatecall failed) revert, or else (default): return
            switch result
            case 0 {revert(ptr, size)}
            default {return(ptr, size)}
        }
    }

}