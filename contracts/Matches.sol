pragma solidity >=0.4.21 <0.7.0;
import "./Ranking.sol";
import "./Labyrinth.sol";

contract Matches is Ranking {
  address owner;
  mapping (address => Labyrinth) public matches; // Current matches

  constructor() public {
    owner = msg.sender;
  }

  modifier onlyOwner() {
    if (msg.sender == owner) _;
  }

  modifier onlyOwnerOrPlayer(address player) {
    if (msg.sender == owner || msg.sender == player) _;
  }
  
  function _verifyMatchExists(address player) internal view {
    require(matches[player] != Labyrinth(0), 'Match should exist');
  }

  modifier doesMatchExist(address player) {
    _verifyMatchExists(player);
    _;
  }

  // Begins a new match or restarts an existent one for a given player
  function startMatch(address player, uint8 position, uint8 lastPosition) public onlyOwnerOrPlayer(player) {
    // Creates a new Labyrinth instance with its initial and ending position
    matches[player] = new Labyrinth(player, position, lastPosition);
  }

  // Adds move for a player's map
  function addMove(address player, uint8 from, uint8 to, Labyrinth.Moves _move) public onlyOwner doesMatchExist(player) {
    matches[player].addMove(from, to, _move);
  }

  // Moves
  function move(address player, Labyrinth.Moves _move) public onlyOwnerOrPlayer(player) doesMatchExist(player) {
    Labyrinth playersMatch = matches[player];
    uint8 moves = playersMatch.move(_move);
    if (playersMatch.currentPosition() == playersMatch.lastPosition()) {
      // Adds player to ranking
      this.addToRanking(player, moves);
    }
  }

  // Moves back
  function moveBack(address player) public onlyOwnerOrPlayer(player) doesMatchExist(player) {
    matches[player].moveBack();
  }

  // Ends matches for given players
  function endMatches(address[] memory players) public onlyOwner {
    for (uint i = 0; i < players.length; i++) {
      _verifyMatchExists(players[i]);
      matches[players[i]].cleanMoves();
      delete matches[players[i]];
    }
  }

  // Ends match
  function endMatch(address player) public onlyOwnerOrPlayer(player) doesMatchExist(player) {
    matches[player].cleanMoves();
    delete matches[player];
  }
}
