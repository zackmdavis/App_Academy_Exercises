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

console.log(exp2(2,6))


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
    // TODO
  }

}

