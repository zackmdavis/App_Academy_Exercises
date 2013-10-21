function Cat (name, owner) {
  this.name = name,
  this.owner = owner
};

Cat.prototype.cuteStatement = function() {
    console.log(this.owner + ' loves ' + this.name);
};

var bfast = new Cat('breakfast', 'ned');
var j = new Cat('Jennifer Q. Catt', 'Carl Userton III');
var r = new Cat('Opalesence', 'Rarity');


bfast.cuteStatement();
j.cuteStatement();
r.cuteStatement();

Cat.prototype.cuteStatement = function() {
  console.log('Everyone loves ' + this.name);
}

bfast.cuteStatement();
j.cuteStatement();
r.cuteStatement();

Cat.prototype.meow = function() {
  console.log("Meow!!");
}

bfast.meow();
j.meow();
r.meow();

bfast.meow = function() {
  console.log("This is highly unusual");
}

bfast.meow();
j.meow();
