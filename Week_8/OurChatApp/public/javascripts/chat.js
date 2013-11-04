(function(root){
  var Chat = root.Chat = (root.Chat || {})

  Chat.chatSocket = function(socket) {
    this.socket = socket;
  }

  Chat.chatSocket.prototype.sendMessage = function(message) {
    this.socket.emit("message", message);
  }

})(this);