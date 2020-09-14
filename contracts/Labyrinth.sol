pragma solidity >=0.4.21 <0.7.0;

contract Labyrinth {
  address owner;
  address player;
  uint8 public currentPosition; // Player's current position in the labyrinth
  uint8 public moves; // Player's number of total moves
  uint8 public lastPosition; // Map's ending position
  uint8[] public lastMoves; // Player's sequence of moves 
  enum Moves { Left, Right, Top} // Possible moves
  mapping (uint8 => mapping (uint8 => uint8)) map; // Current available moves
  event Move(address, uint8, uint8);
  event WinnedMatch(address, uint8);

  constructor(address _player, uint8 position, uint8 _lastPosition) public {
    owner = msg.sender;
    player = _player;
    currentPosition = position;
    lastMoves.push(currentPosition);
    lastPosition = _lastPosition;
    moves = 0;
  }

  modifier onlyOwner() {
    if (msg.sender == owner) _;
  }

  modifier isValidMove(uint8 position, Moves _move) {
    require(map[position][uint8(_move)] != 0, 'Invalid move');
    _;
  }

  modifier doPreviousMovesExist() {
    require(lastMoves.length > 1, 'No back position');
    _;
  }

  // Deletes available moves for given position
  function _deleteMovesForPosition(uint8 position) internal {
    if (map[position][uint8(Moves.Left)] != 0) delete map[position][uint8(Moves.Left)];
    if (map[position][uint8(Moves.Right)] != 0) delete map[position][uint8(Moves.Right)];
    if (map[position][uint8(Moves.Top)] != 0) delete map[position][uint8(Moves.Top)];
  }

  function _updatePosition(uint8 oldPosition, uint8 newPosition) internal {
    // Updates player position
    currentPosition = newPosition;
    // Updates the number of total moves
    moves++;
    // Deletes moves for last position
    _deleteMovesForPosition(oldPosition);
    emit Move(player, oldPosition, currentPosition);
  }

  // Makes a move for player
  function move(Moves _move) external onlyOwner isValidMove(currentPosition, _move) returns (uint8) {
    // Updates player position
    _updatePosition(currentPosition, map[currentPosition][uint8(_move)]);
    // Adds player new position in its sequence of moves
    lastMoves.push(currentPosition);
    if (currentPosition == lastPosition) {
      // If current position matches with last position, the player wins
      emit WinnedMatch(player, moves);
      delete lastMoves;
    }
    return moves;
  }

  // Goes back one position
  function moveBack() external onlyOwner doPreviousMovesExist {
    // Removes and stores last position
    uint8 oldPosition = lastMoves[lastMoves.length - 1];
    lastMoves.pop();
    // Updates player position
    _updatePosition(oldPosition, lastMoves[lastMoves.length - 1]);
  }

  // Adds a new available move to map
  function addMove(uint8 from, uint8 to, Moves _move) external onlyOwner {
    map[from][uint8(_move)] = to;
  }

  // Cleans all moves
  function cleanMoves() external onlyOwner {
    delete lastMoves;
    _deleteMovesForPosition(currentPosition);
  }
}
