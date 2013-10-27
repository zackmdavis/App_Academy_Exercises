// WakeboardGame module

// Okay, it's like this---
(function(root){

    // We're defining a blank _object_ in the global namespace, and
    // then monkeypatching functions into it
    var WakeboardGame = root.WakeboardGame = (root.WakeboardGame || {});

    var Boat = WakeboardGame.Boat = function(sponsor) {
	this.sponsor = sponsor;
    };

    Boat.prototype.power = function() {return "power";}
    Boat.prototype.turn = function() {return "turn";}
    Boat.prototype.sink = function() {return "sink";}
    
    var Wakeboarder = WakeboardGame.Wakeboarder = function(name, sponsor) {
	this.name = name;
	this.sponsor = sponsor;
    };

    Wakeboarder.prototype.jump = function() {return "jump";}
    Wakeboarder.prototype.spin = function() {return "spin";}
    Wakeboarder.prototype.grind = function() {return "grind";}
    Wakeboarder.prototype.crash = function() {return "crash";}

})(this);
