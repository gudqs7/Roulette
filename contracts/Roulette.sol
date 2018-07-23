pragma solidity ^0.4.23;

import './ArrayUtil.sol';

contract Roulette {
    address public owner;
    uint public randNonce = 0;
    uint public buyCount = 0;

    uint ALL_CUSTOMER = 10; // 限定被买多少次开启转盘
    uint TIMES = 10;        // 设定转几次转盘

    mapping(address => uint) public P;
    address [] public addresses;
    address public winner;

    constructor() public {
        owner = msg.sender;
    }

    function buyKey() {
        address key = msg.sender;
        //TODO 买 key 的钱转到 owner
        buyCount++;
        bool exists = ArrayUtil.contains(addresses, key);
        if (exists) {
            P[key] = P[key] + p();
        } else {
            addresses.push(key);
            P[key] = p();
        }
        check();
    }

    function select() returns (uint){
        address key = msg.sender;
        return P[key];
    }

    function p() returns (uint){
        return 1;
    }

    address [] public tempArray;

    function check() {
        if (buyCount >= ALL_CUSTOMER) {
            for (uint i = 0; i < TIMES; i++) {
                address temp = roulette();
                tempArray.push(temp);
            }
            uint random = uint(keccak256(now, msg.sender, randNonce)) % TIMES;
            randNonce++;
            winner = tempArray[random];
            //TODO 把所有钱转给 winner
        }
    }


    function roulette() returns (address) {
        uint random = uint(keccak256(now, msg.sender, randNonce)) % ALL_CUSTOMER;
        randNonce++;
        uint pointer = 0;
        for (uint i = 0; i < addresses.length; i++) {
            pointer += P[addresses[i]];
            if (random <= pointer) {
                return addresses[i];
            }
        }
        return 0x00;
    }

}
