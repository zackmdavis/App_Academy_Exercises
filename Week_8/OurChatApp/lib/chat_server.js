var createChat = function(server){
  var io = require('socket.io').listen(server);

  var connectionCallBack = function(socket){
    console.log("Connected!!");
    socket.on("message", function(data){
      console.log("recieving: " + data);
      io.sockets.emit('message', data)
    });
  };

  io.sockets.on('connection', connectionCallBack);
};


module.exports = createChat;
