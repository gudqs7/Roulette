pragma solidity ^0.4.23;

import './ArrayUtil.sol';

contract Roulette {

    // --------  程序计数 ---------
    uint public randNonce = 0;          // 随机数(不安全)
    uint public buyCount = 0;           // 购买数量
    uint public allMoney = 0;           // 支付ether 总量统计

    // --------  设定 ---------
    uint payMoney = 1000000000000000000;// 买key的钱: 1 ether
    uint ALL_CUSTOMER = 10;             // 限定被买多少次开启转盘
    uint TIMES = 10;                    // 设定转几次转盘


    // --------  程序数据 ---------
    mapping(address => uint) public P;  // 存储玩家对应概率
    address [] public addresses;        // 储存所有玩家地址, 用于遍历 P
    address public owner;               // 奖池存放地址
    uint public status;                 // 1.进行中  2.已结束  0.保留

    address public winner;              // 最后获胜者地址

    constructor() public payable{
        owner = this;
        status = 1;
    }

    function getBalance() constant returns (uint){
        return this.balance;
    }

    function buyKey() payable {
        require(status == 1, 'Not running!');
        require(msg.value == payMoney, 'You need pay 1 gwei!');
        require(buyCount < ALL_CUSTOMER, 'Sell out, wait for open!');

        address key = msg.sender;
        bool exists = ArrayUtil.contains(addresses, key);
        if (exists) {
            require(P[key] / p() < ALL_CUSTOMER / 4, 'You can not buy more than 1/4!');
            P[key] = P[key] + p();
        } else {
            addresses.push(key);
            P[key] = p();
        }

        uint money = msg.value;
        address(owner).send(money);

        allMoney = allMoney + money;
        buyCount++;
        if (buyCount == ALL_CUSTOMER) {
            status = 2;
            check();
        }
    }

    function select() returns (uint){
        address key = msg.sender;
        return P[key];
    }

    function p() returns (uint){
        return 1;
    }

    address [] tempArray;

    function check() payable {
        require(status == 2, 'Not Over!');

        for (uint i = 0; i < TIMES; i++) {
            address temp = roulette();
            tempArray.push(temp);
        }
        uint random = uint(keccak256(now, msg.sender, randNonce)) % TIMES;
        randNonce++;
        winner = tempArray[random];
        //最后 用合约地址账户调用此方法
        address(winner).transfer(address(owner).balance);
        clear();
    }

    /**
     * 清盘
     */
    function clear() {
        for (uint i = 0; i < addresses.length; i++) {
            delete P[addresses[i]];
        }
        delete addresses;
        delete tempArray;
        delete buyCount;
        status = 1;
    }

    /**
     * 轮盘赌算法
     */
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
