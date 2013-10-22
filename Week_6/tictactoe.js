(function(root) {
  Array.prototype.col = function(j) {
    col = [];
    for(i=0; i<this.length; i++){
      col.push(this[i][j]);
    }
    return col;
  }

  Array.prototype.transpose = function() {
    transp = [];
    for(j=0; j<this[0].length; j++){
      transp.push(this.col(j));
    }
    return transp;
  }

  function Board() {
    this.tiles = [[null, null, null], [null, null, null],[null, null, null]]
  }

  Board.prototype.move = function (row,column, current_player) {
    if (this.validMove(row,column)) {
      this.tiles[row][column] = current_player}
    }

    Board.prototype.validMove = function (row, column) {
      return this.tiles[row][column] === null
    }

    Board.prototype.isWon = function () {
      var lines = this.allLines();
      return lines.some(function(line){
        return line.every(function(tile) {return tile === 'X'}) || line.every(function(tile) {return tile === 'O'})
      });
    }

    Board.prototype.allLines = function () {
      var lines = []; var that = this;
      this.tiles.forEach (function (row) {
        lines.push(row)
      });
      this.tiles.transpose().forEach(function (row) {
        lines.push(row)
      });
      diag1 = [];
      diag2 = [];
      for (i = 0; i < 3; i++) {
        diag1.push(this.tiles[i][i]);
        diag2.push(this.tiles[2-i][i]);
      }
      lines.push(diag1);
      lines.push(diag2);
      return lines;
    }

    function Game() {
      this.board = new Board();
      this.current_player = "X"
      this.askForMove();
    }

    var readline = require('readline');
    var reader = readline.createInterface({
      input: process.stdin,
      output: process.stdout
    });

    Game.prototype.askForMove = function() {
      that = this;
      console.log(that.board.tiles);
      reader.question("Enter a move like (row,col)", function(input) {
        inputs = input.split(',');
        row = parseInt(inputs[0]);
        col = parseInt(inputs[1]);
        if (that.board.validMove(row, col)) {
          that.board.move(row, col, that.current_player);
          that.current_player = (that.current_player == 'X') ? 'O' : 'X';
        }
        else {console.log ("BAD MOVE")}
        if (that.board.isWon()) {
          console.log("GAME OVER ", that.current_player, " loses");
        } else {
          that.askForMove();
        }
      });
    }

    our_game = new Game();

  })(this);


