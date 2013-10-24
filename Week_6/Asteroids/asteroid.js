(function(root){
  var Asteroids = root.Asteroids = (root.Asteroids || {});

  var inherits = function(child, parent) {
    function Surrogate() {}
    Surrogate.prototype = parent.prototype;
    child.prototype = new Surrogate();
  }

  var Asteroid = Asteroids.Asteroid = function(pos, vel) {
    var COLOR = "#AAAAAA";
    var RADIUS = 20;
    MovingObjects.MovingObject.call(this, pos, vel, RADIUS, COLOR);
  };

  inherits(Asteroid, root.MovingObjects.MovingObject);

  //Asteroid.prototype.
  var randomAsteroid = Asteroids.randomAsteroid = function(dimX, dimY){
    var MAX_STARTING_VELOCITY = 0.01;
    var starting_pos = [Math.random()*dimX, Math.random()*dimY];
    var starting_vel = [Math.random()*MAX_STARTING_VELOCITY*((Math.random() > 0.5) ? -1 : 1),
      Math.random()*MAX_STARTING_VELOCITY*((Math.random() > 0.5) ? -1 : 1)];
    return new Asteroid(starting_pos, starting_vel);
  }



})(this);