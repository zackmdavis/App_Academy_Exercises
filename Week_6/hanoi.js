// (function (root) {
//   var Hanoi = root.Hanoi = (root.Hanoi || {});
//   .
//   .
//   .
// })(this);

function Pegs() {
  this.pegs = [[3, 2, 1], [], []];
}

Pegs.prototype.at = function(idx) {
  return this.pegs[idx];
}

Pegs.prototype.top_disc = function (idx) {
  if (this.at(idx).length === 0) return 0;
  else return this.at(idx)[this.at(idx).length];
}

Pegs.prototype.move = function(from, to) {
  this.at(to).push(this.at(from).pop());
}

Pegs.prototype.legalMove = function(from, to) {
  return this.top_disc(from) < this.top_disc(to);
}

our_pegs = new Pegs();
our_pegs.move(0,1)
our_pegs.move(0,2)
console.log(our_pegs)

// function Game() {
//
//
// }