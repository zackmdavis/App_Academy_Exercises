(function(root){
  var Chat = root.Chat = (root.Chat || {})

  Chat.chatSocket = function(socket) {
    this.socket = socket;
  }

  Chat.chatSocket.prototype.sendMessage = function(message) {
    if(message.slice(0,1) === '/'){
      this.processCommand(message.slice(1));
    } else {
      this.socket.emit("message", message);
    }
  }

  Chat.chatSocket.prototype.processCommand = function(input){
    var command = input.split(' ')[0];
    var param = input.split(' ')[1];

    if (command === 'nick'){
      this.socket.emit('nicknameChangeRequest', param);
    } else {
      this.sendMessage('Someone submitted an incorrect command!')
    }
  }

})(this);