pragma solidity 0.5.1;

contract Storage {
    mapping(string => uint256) _uintStorage;
    // _uintStorage["Number"] = 10;
    // _uintStorage["NrOfCats"] = 200;
    // _uintStorage["Version"] = 2;

    mapping(string => address) _addressStorage;
    mapping(string => string) _stringStorage;
    mapping(string => bool) _boolStorage;
    mapping(string => bytes4) _bytesStorage;

    address public owner;
    bool public _initialized;

}