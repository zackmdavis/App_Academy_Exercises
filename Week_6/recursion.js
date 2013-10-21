var range = function(start, end) {
  if (start === end){
    return [start];
  }
  else {
    return range(start,end-1).concat([end]);
  }
}
//
// console.log(range(5,50))



Array.prototype.sum_iter = function() {
  sum = 0;
  for(i=0; i<this.length;i++) {
    sum += this[i];
  }

  return sum;
}


Array.prototype.sum_recur = function() {
  if (this.length === 0)
  {
    return 0
  }

  return this[0] + this.slice(1,this.length).sum_recur()
}

// console.log([1,2,3,4,5].sum_recur())


var exp1 = function(base, exp) {
  if(exp === 0) {
    return 1;
  }
  else {
    return base * exp1(base, exp-1);
  }
}

// console.log(exp1(2,5))


var exp2 = function(base, exp) {
  if(exp === 0) {
    return 1;
  }
  else if (exp%2 === 0) {
    var z = exp2(base, exp/2);
    return z * z;
  }

  else {
    var z = exp2(base, (exp-1)/2);
    return base * z * z;
  }

}

// console.log(exp2(2,6))


var fibs = function(n) {
  if (n === 0){
    return [];
  }
  else if (n===1){
    return[1];
  }
  else if (n===2) {
    return [1,1];
  }

  else {
    var z = fibs(n-1)
    return z.concat(z[z.length-1] + z[z.length-2])

  }
}

// console.log(fibs(15))

Array.prototype.binary_search = function(target) {
  center = Math.floor(this.length/2)
  if (this[center] === target) {
    return center;
  }
  else if (this[center] < target) {
    return center + this.slice(center, this.length).binary_search(target);
  }
  else {
    return this.slice(0, center).binary_search(target);
  }
}

// a = [1,2,3,4,5,6,7,8,9];
// console.log(a.binary_search(2));
// console.log(a.binary_search(5));
// console.log(a.binary_search(9));

var change = function(n) {
  var denominations = [25, 10, 5, 1]
  if (n === 0) {
    return [];
  }
  else {
    for (i=0; i<5; i++) {
      if (denominations[i] <= n) {
        return [denominations[i]].concat(change(n-denominations[i]));
      }
    }
  }
}

// console.log(change(25));
// console.log(change(37));
// console.log(change(216));

var merge = function(left, right) {
  merged = []
  var target_length = right.length + left.length;
  while (merged.length < target_length) {
    if (left.length === 0) {
      merged = merged.concat(right);
    }

    else if (right.length === 0) {
      merged = merged.concat(left);
    }

    else {
      if (left[0] < right[0]) {
        merged.push(left.shift());
      }
      else {
        merged.push(right.shift());
      }
    }

  }
  return merged;
}

Array.prototype.mergesort = function() {

  if ((this.length === 0) || (this.length === 1)) {
    return this;
  }

  var center = Math.floor(this.length/2);

  var left = this.slice(0, center);
  var right = this.slice(center, this.length);

  left = left.mergesort();
  right = right.mergesort();

  return merge(left, right);
}

// a = [23,12,62,35,23,57]
// console.log(a.mergesort());

Array.prototype.subsets = function() {
  if (this.length === 0) {
    return [[]];
  } else {
    var z = this.slice(0, this.length-1).subsets();
    var y = z.slice(0, z.length);

    for(i=0; i<y.length; i++){
      y[i] = y[i].concat([this[this.length-1]])
    }

    return z.concat(y);
  }
};

Array.prototype.subsets_redux = function() {
  if (this.length === 0) {
    return [[]];
  }
  else {
    var subproblem = this.slice(0, this.length-1).subsets();
    var subs = [];

    for (var i = 0; i < subproblem.length; i++) {
      subs.push(subproblem[i]);
      subs.push(subproblem[i].concat([this[this.length-1]]));
    }
    return subs;
  }
};

a = [1,2,3,4,5];
console.log(a.subsets_redux());