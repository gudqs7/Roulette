
## 轮盘赌合约规则介绍(初版)
 
>1.每个玩家可以购买任意多的 key

>2.玩家购买 key 数量越多, 所属轮盘扇区越大, 中奖概率越大

>3.当购买数量达到设定值时, 将转动轮盘(使用轮盘赌算法模拟), 最后指针停下的扇区所属人获奖, 赢取所有人买 key 的 eth

## 程序使用指南

```
# 启动ganache-cli
ganache-cli
# 编译合约
truffle compile
# 部署合约
truffle migrate
#打开控制台 
truffle console
#进入后执行
let contract;
Roulette.deployed().then(instance => contract = instance);
contract.buyKey({from: web3.eth.accounts[1]});#替换 account, 执行10次
contract.winner(); #查看 winner, 然后根据地址查看余额情况
```