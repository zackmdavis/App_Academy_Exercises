(function(root){
  var AsteroidsGame = root.AsteroidsGame = (root.AsteroidsGame || {});

  var Game = AsteroidsGame.Game = function(ctx){
    this.ctx = ctx;
    this.dimX = 400;
    this.dimY = 400;
    this.ship = new Ship.ship([200,200], [0,0]);
    // this.asteroids = [new Asteroids.Asteroid([100,100],[0,0])]
    this.asteroids = this.addAsteroids(6, this.dimX, this.dimY);
    this.bullets = [];
    var our_ship = this.ship;
    var that = this;
    key('w', function() { our_ship.power([0,-0.01]) });
    key('a', function() { our_ship.power([-0.01,0]) });
    key('s', function() { our_ship.power([0,0.01]) });
    key('d', function() { our_ship.power([0.01,0]) });
    key('space', function() { that.fireBullet() });
    }

    Game.prototype.addAsteroids = function(n, dimX, dimY){
      var asteroids = [];
      for (var i = 0; i < n; i++){
        var candidateAsteroid = Asteroids.randomAsteroid(dimX, dimY);
        if (!candidateAsteroid.isCollidedWith(this.ship)){
          asteroids.push(candidateAsteroid);
        }
        else {
          i--;
        }
      }
      return asteroids;
    }

    Game.prototype.draw = function(){
      this.ctx.clearRect(0, 0, this.dimX, this.dimY);
      for(var i = 0; i < this.asteroids.length; i++){
        this.asteroids[i].draw(this.ctx);
      }
      this.ship.draw(this.ctx);
      for(var i = 0; i < this.bullets.length; i++){
        this.bullets[i].draw(this.ctx);
      }

    }

    Game.prototype.move = function(){
        for(var i = 0; i < this.asteroids.length; i++){
        this.asteroids[i].move(300);
      }
      this.ship.move(100);
      for(var i = 0; i < this.bullets.length; i++){
        this.bullets[i].move(300);
    }

    }

    // thanks to http://stackoverflow.com/a/9815010
    Array.prototype.remove = function(from, to) {
      var rest = this.slice((to || from) + 1 || this.length);
      this.length = from < 0 ? this.length + from : from;
      return this.push.apply(this, rest);
    };

    Game.prototype.remove_out_of_bounds = function(){
      for(var i = 0; i < this.bullets.length; i++){
        if(this.bullets[i].pos[0] >= this.dimX + 20
          || this.bullets[i].pos[1] >= this.dimY + 20
            || this.bullets[i].pos[0] <= 0 -20){
          this.bullets.remove(i);
        }
      }
      for(var i = 0; i < this.asteroids.length; i++){
        if(this.asteroids[i].pos[0] >= this.dimX + 20
          || this.asteroids[i].pos[1] >= this.dimY + 20
            || this.asteroids[i].pos[0] <= 0 -20){
          this.asteroids.remove(i);
        }
      }
    }

    Game.prototype.checkCollisions = function(){
      for(var i = 0; i < this.asteroids.length; i++){
        if (this.ship.isCollidedWith(this.asteroids[i])) {
          alert("You lose.");
          this.stop();
        }
      }
    }

    Game.prototype.fireBullet = function() {
      this.bullets.push(this.ship.fireBullet());
    }

    Game.prototype.hitAsteroids = function() {
      for(var i = 0; i < this.bullets.length; i++) {
        for(var j = 0; j < this.asteroids.length; j++) {
          if (this.bullets[i].isCollidedWith(this.asteroids[j])){
            // var new_directions = this.orthogonal_vectors([this.bullets[i].vel[0]/this.ship.GUN_SPEED, this.bullets[i].vel[1]/this.ship.GUN_SPEED]);
            // var new_directions = [[-0.02, -0.03],[0.02, 0.02]]
            // var new_asteroids = [new Asteroids.Asteroid(this.asteroids[j].pos, new_directions[0]),
            //               new Asteroids.Asteroid(this.asteroids[j].pos, new_directions[1])]
            // this.asteroids = this.asteroids.concat(new_asteroids);
            this.bullets.remove(i);
            this.asteroids.remove(j);
          }
        }
      }
    }

    Game.prototype.orthogonal_vectors = function(vect) {
       return [[-vect[1], vect[0]], [vect[1], vect[0]]]
      }

    Game.prototype.step = function(){
      this.move();
      this.draw();
      this.checkCollisions();
      this.hitAsteroids();
      this.remove_out_of_bounds();
    }

    Game.prototype.start = function(){
      var game = this;
      this.timer_id = window.setInterval(function() {game.step()}, 100)
    }

    Game.prototype.stop = function(){
      window.clearInterval(this.timer_id);
    }


})(this);