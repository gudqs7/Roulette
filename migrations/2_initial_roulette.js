var Migrations = artifacts.require("./Roulette.sol");

module.exports = function(deployer) {
  deployer.deploy(Roulette);
};
