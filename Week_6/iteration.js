n=1
while (n<=250 || n%7 != 0) {
  n++
}

// console.log(n)

var factors = function(n) {
  facts = []

  for(i=1; i <= n; i++) {
    if (n%i === 0) {
      facts.push(i);
    }
  }
  return facts;

};

// console.log(factors(36))

Array.prototype.bubble_sort = function() {
  for (i=0; i<this.length-1; i++) {
    for (j=i+1; j<this.length; j++) {
      if (this[i] > this[j] ) {
        var swap = this[i];
        this[i] = this[j];
        this[j] = swap;
        console.log(this);
      }
    }
  }
}

// a = [3,7,4,8,3,84,6,2];
// a.bubble_sort();
// console.log(a);

String.prototype.substrings = function() {
  subs = [];
  for (i=0; i<this.length; i++) {
    for (j=i+1; j<this.length+1; j++) {
      subs.push(this.substring(i, j));
    }
  }
  return subs;
}

// cat = "cat";
// console.log(cat.substrings());