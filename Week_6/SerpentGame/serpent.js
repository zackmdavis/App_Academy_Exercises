(function(root){

  var SerpentGame = root.SerpentGame = ( root.SerpentGame || {})

  var Serpent = SerpentGame.Serpent = function() {
    this.direction = new Coordinates(0,-1);
    this.segments = [new Coordinates(11,9)];
  }

  Serpent.prototype.move = function() {
    this.segments.unshift(this.segments[0].plus(this.direction));
    this.segments.pop();
  }

  Serpent.prototype.turn = function(newDirection) {
    this.direction = newDirection;
  }

  var Coordinates = SerpentGame.Coordinates = function(row, col) {
    this.row = row;
    this.col = col;
  }

  Coordinates.prototype.plus = function(otherCoordinates) {
    return new Coordinates(this.row + otherCoordinates.row, this.col + otherCoordinates.col);
  }

  var Territory = SerpentGame.Territory = function() {
    this.serpent = new Serpent();
    this.mice = [];
    this.introduceMice(5);
  }

  Territory.prototype.introduceMice = function(n) {
    for (i = 0; i < n; i++){
      this.mice.push(randomCoordinates());
    }
  }

  var randomCoordinates = SerpentGame.randomCoordinates = function() {
    return new Coordinates(Math.floor(Math.random()*25), Math.floor(Math.random()*31))
  }

  Territory.prototype.render = function() {
    this.array = []
    for (var i  = 0; i < 25; i++ ){
      this.array.push(new Array(31));
    }
    for (var i = 0; i < this.serpent.segments.length; i++) {
      var segment = this.serpent.segments[i];
      this.array[segment.row][segment.col] = 'S';
    }
    this.mice.forEach(function(m) {
      this.array[m.row][m.col] = '$';
    });

    this.array.forEach(function(row) {
      console.log(row);
    });
  }

  })(this);