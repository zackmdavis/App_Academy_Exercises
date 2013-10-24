(function(root){
  var MovingObjects = root.MovingObjects = (root.MovingObject || {});

 var MovingObject = MovingObjects.MovingObject = function(pos, vel, radius, color){
  this.pos = pos;
  this.vel = vel;
  this.radius = radius;
  this.color = color;
}

MovingObject.prototype.move = function(delta){
  this.pos[0] += this.vel[0] * delta;
  this.pos[1] += this.vel[1] * delta;
}

MovingObject.prototype.draw = function(ctx){
  ctx.fillStyle = this.color;
  ctx.beginPath();

  ctx.arc(
    this.pos[0],
    this.pos[1],
    this.radius,
    0,
    2 * Math.PI,
    false
  );
  ctx.fill();
}

MovingObject.prototype.isCollidedWith = function(otherObject){
  distance = Math.sqrt(
    Math.pow(this.pos[0] - otherObject.pos[0],2) + Math.pow(this.pos[1] - otherObject.pos[1], 2)
  );
  return (otherObject.radius + this.radius > distance);
}
})(this);