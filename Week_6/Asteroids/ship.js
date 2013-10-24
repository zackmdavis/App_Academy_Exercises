(function(root){
  var Ship = root.Ship = (root.Ship || {});

  var inherits = function(child, parent) {
    function Surrogate() {}
    Surrogate.prototype = parent.prototype;
    child.prototype = new Surrogate();
  }

  var Ship = Ship.ship = function(pos, vel) {
    var COLOR = "#2233AA";
    var RADIUS = 20;
    this.ENGINE = 0.01;
    this.GUN_SPEED = 0.08;
    MovingObjects.MovingObject.call(this, pos, vel, RADIUS, COLOR);
  };

  inherits(Ship, root.MovingObjects.MovingObject);

  Ship.prototype.power = function(impulse) {
    this.vel[0] += impulse[0];
    this.vel[1] += impulse[1];
  }

  var Bullet = Ship.Bullet = function(pos, vel){
    this.pos = pos;
    this.vel = vel;
    var COLOR = "#AA3388";
    var RADIUS = 2;
    MovingObjects.MovingObject.call(this, pos, vel, RADIUS, COLOR);
  }

  inherits(Bullet, root.MovingObjects.MovingObject);

  Ship.prototype.direction = function() {
    var speed = Math.sqrt(Math.pow(this.vel[0],2) + Math.pow(this.vel[1],2));
    return [this.vel[0]/speed, this.vel[1]/speed];
  }

  Ship.prototype.fireBullet = function(){
    if (this.vel != 0){
      return new Bullet(this.pos.slice(), [this.direction()[0]*this.GUN_SPEED, this.direction()[1]*this.GUN_SPEED]);
    }
  }


})(this);