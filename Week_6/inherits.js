var inherits = function(child, parent) {
  function Surrogate() {}
  Surrogate.prototype = parent.prototype;
  child.prototype = new Surrogate();
}

function MovingObject() {};
MovingObject.prototype.shootAwesomeLasers = function() {
  console.log("Lasers! Yay!");
}

function Ship () {};
inherits(Ship, MovingObject);

function Asteroid () {};
inherits(Asteroid, MovingObject);

uss_enterprise = new Ship();
uss_enterprise.shootAwesomeLasers();
