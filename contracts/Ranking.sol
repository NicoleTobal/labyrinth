pragma solidity >=0.4.21 <0.7.0;

contract Ranking {
  // Struct for a matches result
  struct PlayersResult {
    address player;
    uint8 moves;
    uint date;
  }
  mapping (address => PlayersResult[]) results; // Results of all users
  event AddedToRanking(uint, address, uint8, uint);

  modifier isPlayerOnTheRanking(address player) {
    require(results[player].length != 0, "Player is not on the ranking");
    _;
  }

  modifier isIndexValid(address player, uint index) {
    require(index < results[player].length, "Ranking doesn't exist for given index");
    _;
  }

  // Adds player'result to ranking
  function addToRanking(address player, uint8 moves) external {
    PlayersResult memory newResult = PlayersResult(player, moves, now);
    results[player].push(newResult);
    emit AddedToRanking(results[player].length, player, moves, newResult.date);
  }

  // Gets a user's result data
  function getUsersResultData(address player, uint index) view public isPlayerOnTheRanking(player) isIndexValid(player, index) returns (address, uint8, uint) {
    PlayersResult memory resultData = results[player][index];
    return (resultData.player, resultData.moves, resultData.date);
  }
}
