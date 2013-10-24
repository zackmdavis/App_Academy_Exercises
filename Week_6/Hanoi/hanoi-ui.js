var buildTowers = function() {
  var towers = Game.towers;
  for (var i = 1; i <= 3; i++){
    for (var j = towers[i-1].length - 1; j>=0; j--) {
      $('#peg'+i).append("<div id= 'disc" + j + "'>")
      $('#peg'+i+' #disc' + j).addClass("disc"+towers[i-1][j]);
    }
  }
}


$(document).ready(function(){
  buildTowers();
  discs = [$('#disc1'), $('#disc2'), $('#disc3')]
  for (var i=0; i<discs.length; i++){
    discs[i].click(function(e){
      alert("hi");
    });

  }
  // $('#disc').onClick(function(e){
  //
  // });


});