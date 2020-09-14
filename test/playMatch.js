const Matches = artifacts.require("Matches");

contract("Matches played", async accounts => {

  let instance;

  beforeEach(async() => {
    const newInstance = await Matches.new();
    instance = newInstance;
    return;
  });

  it("should make invalid move and get an error", async () => {
    let player = accounts[1];
    await instance.startMatch(player, 0, 9);
    // Contract owner adds left move
    await instance.addMove(player, 0, 1, 0);
    try {
      // Player tries to move right
      await instance.move(1, { from: player });
      // If contract allows move, then test failed
      throw new Error('Test failed');
    } catch (error) {
      // Error of invalid move
      assert.equal(error.message, 'Returned error: VM Exception while processing transaction: revert Invalid move -- Reason given: Invalid move.')
    }
  });

  it("should win the match and cannot continue playing", async () => {
    let player = accounts[1];
    await instance.startMatch(player, 0, 9);
    // Contract owner adds left move
    await instance.addMove(player, 0, 9, 0);
    // Player moves left
    await instance.move(0, { from: player });
    try {
      // Player tries to move right
      await instance.move(1, { from: player });
      // If contract allows move, then test failed
      throw new Error('Test failed');
    } catch (error) {
      // Error of invalid move
      assert.equal(error.message, 'Returned error: VM Exception while processing transaction: revert Match should exist -- Reason given: Match should exist.')
    }
  });

  it("should win and appear in ranking", async () => {
    let player = accounts[1];
    await instance.startMatch(player, 0, 9);
    // Contract owner adds left move
    await instance.addMove(player, 0, 1, 0);
    // Player moves left
    await instance.move(0, { from: player });
    // Contract owner adds top move
    await instance.addMove(player, 1, 9, 2);
    // Player moves top and wins
    await instance.move(2, { from: player });
    // Todo: search log
    // Gets ranking
    let rankingData = await instance.getUsersResultData(player, 0);
    assert.equal(rankingData[0], player);
    assert.equal(rankingData[1].toString(), 2);
  });
});