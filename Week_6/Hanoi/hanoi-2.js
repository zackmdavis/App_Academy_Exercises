(function(root) {

  // var readline = require('readline');
  // var reader = readline.createInterface({
  //   input: process.stdin,
  //   output: process.stdout
  // });

  function Pegs() {
    this.pegs = [[3, 2, 1], [], []];
  }

  Pegs.prototype.at = function(idx) {
    return this.pegs[idx];
  }

  Pegs.prototype.top_disc = function (idx) {
    if (this.at(idx).length === 0) return 1/0; // "infinity"
    else return this.at(idx)[this.at(idx).length-1];
  }

  Pegs.prototype.move = function(from, to) {
    if (this.legalMove(from, to)) {
      this.at(to).push(this.at(from).pop());
    } else {
      console.log("You cannot do that");
    }
  }

  Pegs.prototype.legalMove = function(from, to) {
    return (this.top_disc(from) < this.top_disc(to));
  }

  function Game() {
    this.pegs = new Pegs();
    this.askForMove();
  }

  // Game.prototype.askForMove = function () {
  //   that = this;
  //   reader.question("Enter a move like (from,to)", function(input){
  //     var inputs = input.split(',');
  //     var from = parseInt(inputs[0]);
  //     var to = parseInt(inputs[1]);
  //     that.pegs.move(from, to);
  //     console.log(that.pegs);
  //     if (that.isWon()) console.log("A WINNER")
  //     else that.askForMove();
  //   })
  // }

  Game.prototype.isWon = function () {
    var win_pegs = [3,2,1].toString()
    var last_pegs = this.pegs.at(2).toString()
    return win_pegs == last_pegs;
  }

  our_game = new Game();

})(this);


