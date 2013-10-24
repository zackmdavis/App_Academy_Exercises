var buildTowers = function() {
  $('#peg1').remove();
  $('#peg2').remove();
  $('#peg3').remove();
  var towers = Game.towers;
  $('#anchor').prepend('<div class="peg" id ="peg3" data-idx="2">');
  $('#anchor').prepend('<div class="peg" id ="peg2" data-idx="1">');
  $('#anchor').prepend('<div class="peg" id ="peg1" data-idx="0">');
  for (var i = 1; i <= 3; i++){
    for (var j = towers[i-1].length - 1; j>=0; j--) {
      $('#peg'+i).append("<div class = 'disc" + towers[i-1][j] + "'>");
    }
    var stack_size = Game.towers[i-1].length;
    for (k = 0; k < 3-stack_size; k++){
      $('#peg'+i).prepend("<div class='spacer'>")
    }
  }
}

var setHandlers = function() {
  pegs = [$('#peg1'), $('#peg2'), $('#peg3')]
  var startTowerIdx = null;
  for(var pegIdx = 0; pegIdx < 3; pegIdx++){
    var startTowerIdx = null;
    pegs[pegIdx].click(function(e) {
      if (startTowerIdx !== null){
        var endTowerIdx = parseInt($(this).attr("data-idx"));
        console.log("endTower:", endTowerIdx);
        if (!Game.isValidMove(startTowerIdx, endTowerIdx)) {
          alert("Invalid move!!!!!!!");
        }
        Game.takeTurn(startTowerIdx, endTowerIdx);
        startTowerIdx = null;
        gameLoop();
      } else {
        startTowerIdx = parseInt($(this).attr("data-idx"));
        console.log("startTower: ", startTowerIdx);
      }
    });
  }
}



var gameLoop = function() {
  if (!Game.isWon()){
    buildTowers();
    setHandlers();
  } else {
    buildTowers();
    alert("A winner is you!");
  }

}

$(document).ready(function(){
  gameLoop();
});

// pegs[0].click(function(e) {
//   var startTowerIdx = 0;
//   console.log("start handler set");
//   pegs[1].click(function(){
//     var endTowerIdx = 1;
//     console.log("click");
//
//     buildTowers();
//   });
//
// });



  // READER.question("Enter a starting tower: ",function (start) {
  //   var startTowerIdx = parseInt(start);
  //   READER.question("Enter an ending tower: ", function (end) {
  //     var endTowerIdx = parseInt(end);
  //     game.takeTurn(startTowerIdx,endTowerIdx);
  //   });
  // });
  //};