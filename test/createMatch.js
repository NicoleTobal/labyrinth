const Matches = artifacts.require("Matches");

contract("Matches created", async accounts => {
  it("should see that no match exist for given address", async () => {
    let account = accounts[0];
    let instance = await Matches.deployed();
    let currentMatch = await instance.matches.call(account);
    assert.equal(currentMatch, '0x0000000000000000000000000000000000000000');
  });

  it("should create a match for given address", async () => {
    let player = accounts[1];
    let instance = await Matches.deployed();
    await instance.startMatch(player, 0, 9);
    let currentMatch = await instance.matches.call(player);
    assert.notEqual(currentMatch, '0x0000000000000000000000000000000000000000');
  });
});