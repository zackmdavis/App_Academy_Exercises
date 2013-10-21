Array.prototype.my_uniq = function() {
  uniques = [];
  for(i = 0; i < this.length; i++){
    if (uniques.indexOf(this[i]) === -1) {
      uniques.push(this[i]);
    };
  };
  return uniques;
}

// a = [1, 2, 3, 4, 2, 2, 4];
// console.log(a.my_uniq());

Array.prototype.two_sum = function() {
  positions = [];
  for(i=0; i<this.length-1; i++){
    for(j=i+1; j<this.length; j++){
      if (this[i] + this[j] === 0) {
        positions.push([i, j]);
      };
    }
  }
  return positions;
};

// a = [1, -1, 2, 3, 4, -3, 0, 0];
// console.log(a.two_sum());

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

// a = [[1,2,3],[4,5,6],[7,8,9]];
// console.log(a.transpose());