pragma solidity >=0.4.21 <0.7.0;
import "./Ranking.sol";
import "./Labyrinth.sol";

contract Matches is Ranking {
  address owner;
  mapping (address => Labyrinth) public matches; // Current matches
  event MatchStartRequest(address);
  event MatchStarted(address);
  event MatchEnded(address);

  constructor() public {
    owner = msg.sender;
  }

  modifier onlyOwner() {
    if (msg.sender == owner) _;
  }
  
  function _verifyMatchExists(address player) internal view {
    require(matches[player] != Labyrinth(0), 'Match should exist');
  }

  modifier doesMatchExist(address player) {
    _verifyMatchExists(player);
    _;
  }

  // Ends match
  function _endMatch(address player) internal {
    matches[player].cleanMoves();
    delete matches[player];
    emit MatchEnded(player);
  }

  // Requests a new match for a given player
  function requestStartMatch() public {
    emit MatchStartRequest(msg.sender);
  }

  // Begins a new match or restarts an existent one for a given player
  function startMatch(address player, uint8 position, uint8 lastPosition) public onlyOwner {
    // Creates a new Labyrinth instance with its initial and ending position
    matches[player] = new Labyrinth(player, position, lastPosition);
    emit MatchStarted(player);
  }

  // Adds move for a player's map
  function addMove(address player, uint8 from, uint8 to, Labyrinth.Moves _move) public onlyOwner doesMatchExist(player) {
    matches[player].addMove(from, to, _move);
  }

  // Player moves
  function move(Labyrinth.Moves _move) public doesMatchExist(msg.sender) {
    Labyrinth playersMatch = matches[msg.sender];
    uint8 moves = playersMatch.move(_move);
    if (playersMatch.currentPosition() == playersMatch.lastPosition()) {
      // Adds player to ranking
      this.addToRanking(msg.sender, moves);
      _endMatch(msg.sender);
    }
  }

  // Moves back
  function moveBack() public doesMatchExist(msg.sender) {
    matches[msg.sender].moveBack();
  }

  // Ends matches for given players
  function endMatches(address[] memory players) public onlyOwner {
    for (uint i = 0; i < players.length; i++) {
      _verifyMatchExists(players[i]);
      matches[players[i]].cleanMoves();
      delete matches[players[i]];
    }
  }
}
