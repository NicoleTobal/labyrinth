const Matches = artifacts.require("Matches");

contract("Matches played", async accounts => {

  let instance;

  beforeEach(function() {
    return Matches.new()
    .then(function(matchesInstance) {
        instance = matchesInstance;
    });
  });

  it("should make invalid move and get an error", async () => {
    let player = accounts[1];
    await instance.startMatch(player, 0, 9);
    // Contract owner adds left move
    await instance.addMove(player, 0, 1, 0);
    try {
      // Player tries to move right
      await instance.move(player, 1);
      // If contract allows move, then test failed
      throw new Error('Test failed');
    } catch (error) {
      // Error of invalid move
      assert.equal(error.message, 'Returned error: VM Exception while processing transaction: revert Invalid move -- Reason given: Invalid move.')
    }
  });

  it("should win the match and have no moves left", async () => {
    let player = accounts[1];
    await instance.startMatch(player, 0, 9);
    // Contract owner adds left move
    await instance.addMove(player, 0, 9, 0);
    // Player moves left
    await instance.move(player, 0);
    try {
      // Player tries to move right
      await instance.move(player, 1);
      // If contract allows move, then test failed
      throw new Error('Test failed');
    } catch (error) {
      // Error of invalid move
      assert.equal(error.message, 'Returned error: VM Exception while processing transaction: revert No moves left -- Reason given: No moves left.')
    }
  });

  it("should win and appear in ranking", async () => {
    let player = accounts[1];
    await instance.startMatch(player, 0, 9);
    // Contract owner adds left move
    await instance.addMove(player, 0, 1, 0);
    // Player moves left
    await instance.move(player, 0);
    // Contract owner adds top move
    await instance.addMove(player, 1, 9, 2);
    // Player moves top and wins
    await instance.move(player, 2);
    // Todo: search log
    // Gets ranking
    let rankingData = await instance.getUsersResultData(player, 0);
    assert.equal(rankingData[0], player);
    assert.equal(rankingData[1].toString(), 2);
  });
});