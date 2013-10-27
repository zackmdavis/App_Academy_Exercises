Assessment = {};

Assessment.mergeSort = function(array) {
    var merge = function(left, right) {
	var merged = [];
	var merged_length = left.length + right.length;
	while (merged.length < merged_length){
	    if (left.length === 0){
		merged = merged.concat(right);
	    } else if (right.length === 0) {
		merged = merged.concat(left);
	    } else { 
		if (left[0] < right[0]) {
		    merged.push(left.shift());
		} else {
		    merged.push(right.shift());
		}
	    }
	}
	return merged;
    }

    if (array.length <= 1) {
	return array;
    }
    var center = array.length/2;
    var left = Assessment.mergeSort(array.slice(0, center));
    var right = Assessment.mergeSort(array.slice(center, array.length));
    return merge(left, right);
};

Assessment.recursiveExponent = function(base, power) {
    if (power === 0) {
	return 1;
    }
    return base*Assessment.recursiveExponent(base, power-1);
};

Assessment.powCall = function (base, power, callback) {
    var result = Math.pow(base, power);
    callback(result);
    return result;
};

Assessment.transpose = function (matrix) {
    var col = function(c) {
	var column = [];
	matrix.forEach(function(row) { column.push(row[c]) });
	return column;
    };

    var transposed = []
    for(i = 0; i < matrix[0].length; i++) {
	transposed.push(col(i));
    }
    return transposed;

};

Assessment.primes = function (n) {
    var the_primes = [];
    var checking = 2;
    while (the_primes.length < n){
	var prime = true;
	for (i = 2; i < checking; i++){
	    if (checking % i === 0){
		prime = false;
		break;
	    }
	}
	if (prime) {
	    the_primes.push(checking);
	}
	checking++;
    }
    return the_primes;
};

Function.prototype.myCall = function (context, argArray) {
    // actually not quite sure what to do here
};

Function.prototype.inherits = function (Parent) {
    var Surrogate = function() {};
    Surrogate.prototype = Parent.prototype;
    this.prototype = new Surrogate();
};
