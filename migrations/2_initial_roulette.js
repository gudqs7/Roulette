var Roulette = artifacts.require("./Roulette.sol");
var ArrayUtil = artifacts.require("./ArrayUtil.sol");

module.exports = function (deployer) {
    deployer.deploy(ArrayUtil);
    deployer.link(ArrayUtil, Roulette);
    deployer.deploy(Roulette);
};
