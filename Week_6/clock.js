function Clock() {

}

Clock.prototype.tick = function() {
  console.log("testing", this,  this.seconds)
    this.seconds = (this.seconds + 5)%60;
    if (this.seconds < 5) {
        this.minutes = (this.minutes + 1)%60;
        if (this.minutes === 0)
            this.hours = (this.hours + 1)%24;
    }
    console.log("The current time is", this.hours, ":", this.minutes, ":", this.seconds);
}

Clock.prototype.run = function() {
    this.starting_time = new Date();
    this.hours = this.starting_time.getHours();
    this.minutes = this.starting_time.getMinutes();
    this.seconds = this.starting_time.getSeconds();
    console.log("The current time is", this.hours, ":", this.minutes, ":", this.seconds);
    console.log(this)
    setInterval(this.tick.bind(this), 5000);
}

var our_clock = new Clock();
our_clock.run();