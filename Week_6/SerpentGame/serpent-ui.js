(function(root){

  var SerpentGame = root.SerpentGame = ( root.SerpentGame || {})
  var View = SerpentGame.View = function(el) {
    this.el = el;
  }

  var Game = SerpentGame.Game = function() {
  }

  Game.prototype.start = function() {
    this.territory = new SerpentGame.Territory();
    this.TICK = 400;
    $(document).ready(function(){
      for (var row = 0; row < 25; row++){
        $('body').append('<div class="row">');
        for (var square = 0; square < 31; square++){
          $($('body').children()[row]).append('<div class="square">');
        }
      }
    });
    var that = this;
    $(document).keydown(function(e) {
      that.handleKeyEvent(e.which);
    });
    var g = this;
    root.setInterval(function() { g.step(); }, this.TICK);
  }

  Game.prototype.handleKeyEvent = function(key){
    if (key === 37) {
      this.territory.serpent.turn(new SerpentGame.Coordinates(0,-1))
    } else if (key === 38) {
      this.territory.serpent.turn(new SerpentGame.Coordinates(-1,0))
    } else if (key === 39) {
      this.territory.serpent.turn(new SerpentGame.Coordinates(0,1))
    } else if (key === 40) {
      this.territory.serpent.turn(new SerpentGame.Coordinates(1,0))
    } else {
      console.log("irrelevant key");
    }
  }

  Game.prototype.render = function() {
    for (var row = 0; row < 25; row++){
      for (var square = 0; square < 31; square++){
        $($($('body').children()[row]).children()[square]).removeClass('snake')
        $($($('body').children()[row]).children()[square]).addClass('square')
      }
    }
    this.territory.serpent.segments.forEach(function(segment){
      $($($('body').children()[segment.row]).children()[segment.col]).addClass('snake');
    });
    this.territory.mice.forEach(function(segment){
      $($($('body').children()[segment.row]).children()[segment.col]).addClass('mouse');
    })

  };

  // Game.prototype.render = function() {
  //   for (var i = 0; i < this.territory.length; i++) {
  //     for (var j = 0; j < this.territory[0].length; j++) {
  //       $($($('body').children()[i]).children()[j]).addClass('square');
  //     }
  //   }



  Game.prototype.step = function() {
    //console.log(this);
    this.territory.serpent.move();
    this.render();
    console.log(this.territory.serpent.segments[0]);
    //console.log("My dear creators: Hello from the step function. I remain, Your faithful student, Console Log.")
  }

  our_game = new Game();
  our_game.start();

})(this);