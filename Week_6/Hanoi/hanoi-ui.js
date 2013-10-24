var buildTowers = function() {
  $('#peg1').remove();
  $('#peg2').remove();
  $('#peg3').remove();
  var towers = Game.towers;
  $('body').append('<div class="peg" id ="peg1">');
  $('body').append('<div class="peg" id ="peg2">');
  $('body').append('<div class="peg" id ="peg3">');
  for (var i = 1; i <= 3; i++){
    for (var j = towers[i-1].length - 1; j>=0; j--) {
      $('#peg'+i).append("<div class = 'disc" + towers[i-1][j] + "'>");
    }
  }
}


$(document).ready(function(){
  buildTowers();
  pegs = [$('#peg1'), $('#peg2'), $('#peg3')]
  pegs[0].click(function(e) {
    var startTowerIdx = 0;
    console.log("start handler set");
    pegs[1].click(function(){
      var endTowerIdx = 1;
      console.log("click");
      Game.takeTurn(startTowerIdx, endTowerIdx);
      buildTowers();
    });

  });

});


  // READER.question("Enter a starting tower: ",function (start) {
  //   var startTowerIdx = parseInt(start);
  //   READER.question("Enter an ending tower: ", function (end) {
  //     var endTowerIdx = parseInt(end);
  //     game.takeTurn(startTowerIdx,endTowerIdx);
  //   });
  // });
  //};