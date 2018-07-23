pragma solidity ^0.4.23;

import './ArrayUtil.sol';

contract Roulette {
    address public owner;

    // --------  程序计数 ---------
    uint public randNonce = 0; // 随机数(不安全)
    uint public buyCount = 0;  // 购买数量
    uint public allMoney = 0;  // 支付ether 总量统计

    // --------  设定 ---------
    uint payMoney = 1000000000;// 买key的钱: 1gwei
    uint ALL_CUSTOMER = 10; // 限定被买多少次开启转盘
    uint TIMES = 10;        // 设定转几次转盘


    // --------  程序数据 ---------
    mapping(address => uint) public P;
    address [] public addresses;
    address public winner;
    uint public status;     // 1.进行中  2.已结束

    constructor() public payable{
        owner = msg.sender;
        status = 1;
    }

    function getBalance() constant returns (address){
        return this;
    }

    function buyKey() payable {
        require(status == 1, 'Not running!');
        require(msg.value == payMoney, 'You need pay 1 gwei!');
        require(buyCount < ALL_CUSTOMER, 'Sell out, wait for open!');
        address key = msg.sender;
        uint money = msg.value;
        owner.transfer(money);
        allMoney = allMoney + money;
        buyCount++;
        if (buyCount == ALL_CUSTOMER) {
            status = 2;
        }
        bool exists = ArrayUtil.contains(addresses, key);
        if (exists) {
            P[key] = P[key] + p();
        } else {
            addresses.push(key);
            P[key] = p();
        }
    }

    function select() returns (uint){
        address key = msg.sender;
        return P[key];
    }

    function p() returns (uint){
        return 1;
    }

    function check() payable returns (address){
        address [] tempArray;
        require(status == 2, 'Not Over!');
        require(msg.sender == owner, 'Must from contract owner!');
        require(msg.value == allMoney, 'You must pay all!');

        for (uint i = 0; i < TIMES; i++) {
            address temp = roulette();
            tempArray.push(temp);
        }
        uint random = uint(keccak256(now, msg.sender, randNonce)) % TIMES;
        randNonce++;
        winner = tempArray[random];
        //最后 用合约地址账户调用此方法
        winner.transfer(msg.value);
        status = 0;
        clear();
        temp = winner;
        delete winner;
        return temp;
    }

    function clear() {
        for (uint i = 0; i < addresses.length; i++) {
            delete P[addresses[i]];
        }
        delete addresses;
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
