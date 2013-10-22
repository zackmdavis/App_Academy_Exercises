function Piece(color) {
  this.color = color;
}

Piece.prototype.otherColor = function() {
  other = (this.color === 'W') ? 'B' : 'W';
  return other;
}


Piece.prototype.flip = function() {
  this.color = this.otherColor()
}

function Position(row, col) {
  this.row = row;
  this.col = col;
}

Position.prototype.offsetBy = function (direction) {
  return new Position(this.row + direction.row, this.col + direction.col);
}

Position.prototype.dup = function() {
  return new Position(this.row, this.col);
}


function Board() {
  this.board = [['_','_','_','_','_','_','_','_'],
                ['_','_','_','_','_','_','_','_'],
                ['_','_','_','_','_','_','_','_'],
                ['_','_','_',new Piece('W'),new Piece('B'),'_','_','_'],
                ['_','_','_',new Piece('B'),new Piece('W'),'_','_','_'],
                ['_','_','_','_','_','_','_','_'],
                ['_','_','_','_','_','_','_','_'],
                ['_','_','_','_','_','_','_','_']];
}

Board.prototype.display = function () {
  this.board.forEach (function(row) {
    row.forEach (function(square) {
      if (square === "_") {
        process.stdout.write("__");
      } else if (square.color === "W") {
        process.stdout.write("\u25CB ");
      } else {
        process.stdout.write("\u25CF ");
      }
    });
    console.log();
  }
);

}

Board.prototype.at = function(position) {
  // console.log(this.board[position.row][position.col]);
  return this.board[position.row][position.col];
}

Board.prototype.setAt = function(position, color) {
  this.board[position.row][position.col] = new Piece(color);
}

Board.prototype.flipPiecesBetween = function(pos1, pos2) {
  var offset = new Position(pos2.row - pos1.row, pos2.col - pos1.col);
  if (offset.row === 0){
    var displacement = offset.col;
    offset.col /= Math.abs(offset.col);
  } else {
    var displacement = offset.row;
    offset.row /= Math.abs(offset.row);
  }
  var tracking = pos1.offsetBy(offset);
  console.log(displacement);
  for(var i = 0; i < Math.abs(displacement)-1; i++) {
    console.log("flip! ", tracking);
    this.at(tracking).flip();
    tracking = tracking.offsetBy(offset);
  }
}

Board.prototype.placePiece = function(position, color) {
  this.board[position.row][position.col] = new Piece(color);
  var directions = [new Position(1,0), new Position(-1,0), new Position(0,1), new Position(0,-1)];
  for(var d = 0; d < 4; d++){
    var tracking = position.dup();
    tracking = tracking.offsetBy(directions[d]);

    while (this.at(tracking).color === this.at(position).otherColor()){
      tracking = tracking.offsetBy(directions[d]);
    }

    if (this.at(tracking).color == color){
      console.log("I'm in your piece loop, flipping pieces; faithfully yours, console log")
      this.flipPiecesBetween(position, tracking);
    }
  }
  this.setAt(position, color);
}


b = new Board();

b.placePiece(new Position(2,3), "B")
b.placePiece(new Position(1,3), "W")
b.placePiece(new Position(5,3), "W")
b.placePiece(new Position(3,2), "B")

b.display();