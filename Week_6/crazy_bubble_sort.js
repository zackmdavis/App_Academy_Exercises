var readline = require('readline');
var reader = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

function askLessThan(el1, el2, callback) {
  console.log(el1, " < ", el2, " ?");
  reader.question("Is the first element less than the second element?", function(input) {
    (input == "yes") ? callback(true) : callback(false);
  });
}

function performSortPass(arr, i, madeAnySwaps, callback) {
  if (i < arr.length-1){
    askLessThan(arr[i], arr[i+1], function(lessThan) {
      if (lessThan) {} else {
        swap = arr[i];
        arr[i] = arr[i+1];
        arr[i+1] = swap;
        madeAnySwaps = true;
       }
       performSortPass(arr, i+1, madeAnySwaps, callback);
    });
  }
  else {
    callback(madeAnySwaps);
  }
}


function crazyBubblesort(arr, sortCompletionCallback) {
  function sortPassCallback(madeAnySwaps) {
    if (madeAnySwaps) {
      performSortPass(arr, 0, false, sortPassCallback)
    } else {
      sortCompletionCallback(arr);
    }
  }
  sortPassCallback(true);
}

crazyBubblesort([4,3,9,1], function(arr) {console.log("Sorted!", arr)})