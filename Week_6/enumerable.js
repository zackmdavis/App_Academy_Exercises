Array.prototype.multiples = function(n) {
  multiplied = [];
  for (i=0; i<this.length; i++){
    multiplied.push(this[i]*n)
  }
  return multiplied;
}

// a = [1, 2, 3, 4, 5];
// console.log(a.multiples(2));

Array.prototype.our_each = function(prc) {
  for (i=0; i<this.length; i++){
    prc(this[i]);
  }
}

// a = ['I', 'used', 'to', 'wonder']
// a.our_each(console.log);

Array.prototype.our_map = function(prc) {
  mapped = [];
  this.our_each(function (e) { mapped.push(prc(e)) } )
  return mapped;
}

// a = [1, 2, 3, 4]
// console.log(a.our_map(function(n) { return n*2; }));

Array.prototype.my_inject = function(n,prc) {
  var accum_val = n

  this.our_each(function(e) {accum_val = prc(accum_val, e)})

  return accum_val;
}

var add = function(a,b) {
  return a + b;
}

console.log([1,2,3,3].my_inject(0, add))
