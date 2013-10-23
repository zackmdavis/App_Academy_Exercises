// we are dumb and will fix this later

var sum = function() {
  total = 0
  for (i = 0; i < arguments.length; i++){
    total += arguments[i];
  }
  return total;
}

// console.log(sum(1,2,3,4)); // => 10

Function.prototype.myBind = function (obj) {
  var that = this;
  var bindingArgs = Array.prototype.slice.call(arguments, 1, arguments.length);

  return function () {
    var moreArgs = Array.prototype.slice.call(arguments);
    return that.apply(obj, bindingArgs.concat(moreArgs));
  };
}

var Something = function(){};

Something.prototype.sumThreeNumbers = function(a,b,c){
  return a + b + c;
}

ourThing = new Something();

var myBoundFunction = ourThing.sumThreeNumbers.myBind(ourThing, 1, 2)
console.log(myBoundFunction(3))