var readline = require('readline');
var reader = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

function addNumbers(sum, numLefts, completionCallback) {
  if (numLefts > 0) {
    reader.question("Give me your number", function (input) {
      var num = parseInt(input);
      sum += num;
      console.log(sum);
      addNumbers(sum, numLefts - 1, completionCallback)
    })
  }
  else completionCallback(sum);
}

addNumbers(0, 3, function (sum) {
  console.log("Total Sum: " + sum);
});