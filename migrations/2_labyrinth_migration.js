const Matches = artifacts.require("Matches");

module.exports = function(deployer) {
  deployer.deploy(Matches);
};