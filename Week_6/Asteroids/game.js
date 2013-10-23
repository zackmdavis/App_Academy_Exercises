(function(root){
  var AsteroidsGame = root.AsteroidsGame = (root.AsteroidsGame || {});

  var Game = AsteroidsGame.Game = function(ctx){
    this.ctx = ctx;
    this.dimX = 400;
    this.dimY = 400;
    this.asteroids = this.addAsteroids(6, this.dimX, this.dimY);
    }

    Game.prototype.addAsteroids = function(n, dimX, dimY){
      asteroids = [];
      for (var i = 0; i < n; i++){
        asteroids.push(Asteroids.randomAsteroid(dimX, dimY));
      }
      return asteroids;
    }

    Game.prototype.draw = function(){
      this.ctx.clearRect(0, 0, this.dimX, this.dimY);
      for(var i = 0; i < asteroids.length; i++){
        this.asteroids[i].draw(this.ctx);
      }
    }

    Game.prototype.move = function(){
        for(var i = 0; i < asteroids.length; i++){
        this.asteroids[i].move(100);
      }
    }

    Game.prototype.step = function(){
      this.move();
      this.draw();
    }

    Game.prototype.start = function(){
      var game = this;
      window.setInterval(function() {game.step()}, 100)
    }

})(this);