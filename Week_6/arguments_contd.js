var curriedSum = function(numSummands) {
  var numbers = [];
  var _curriedSum = function(arg){
    numbers.push(arg);
    if (numbers.length === numSummands) {
      total = 0;
      for (i = 0; i < numSummands; i++) {
        total += numbers[i];
      }
      return total;
    } else {
      return _curriedSum
    }
  }
  return _curriedSum;
}

// var adder = curriedSum(4);
// console.log(adder(1)(2)(3)(4));

Function.prototype.curry = function(numArgs) {
  var that = this;
  var args = [];
  var _curry = function(arg){
    args.push(arg);
    if (args.length === numArgs){
      return that.apply(null, args);
    } else {
      return _curry;
    }
  }
  return _curry;
}

var multiplyThree = function(a, b, c) {
  return a * b * c;
}

var multiplier = multiplyThree.curry(4);
console.log(multiplier(3)(4)(5)(6));