// WakeboardGame module

// for some reason SpecRunner.html can't find my code here; what am I
// doing wrong??
(function(root){
    var WakeboardGame = root.WakeboardGame = function() {};

    var Boat = WakeboardGame.Boat = function(sponsor) {
	this.sponsor = sponsor;
    };

    Boat.prototype.power = function() {return "power";}
    Boat.prototype.turn = function() {return "turn";}
    Boat.prototype.sink = function() {return "sink";}
    
    
    var Wakeboarder = WakeboardGame.Wakeboarder(name, sponsor) {
	this.name = name;
	this.sponsor = sponsor;
    };

    Wakeboarder.prototype.jump = function() {return "jump";}
    Wakeboarder.prototype.spin = function() {return "spin";}
    Wakeboarder.prototype.grind = function() {return "grind";}
    Wakeboarder.prototype.crash = function() {return "crash";}

})(this);
