var createChat = function(server){
  var io = require('socket.io').listen(server);
  var guestnumber = 0;
  var nicknames = {};
  var namesUsed = {};

  var isValidNickname = function(name){
    return (name.slice(0,5) !== 'guest' && !namesUsed[name])
  };

  var changeNickname = function(name, socket){
    console.log("name" + name)
    if(isValidNickname(name)){
      namesUsed[name] = true;
      var oldName = nicknames[socket.id];
      nicknames[socket.id] = name;
      io.sockets.emit('nicknameChangeResult', {
        success: true,
        message: oldName + " changed name to " + name})
    } else {
      socket.emit('nicknameChangeResult', {
        success: false,
        message: "Don't be silly"});
    }
  };

  var connectionCallBack = function(socket){
    console.log("Num of Guests: " + guestnumber);
    guestnumber++;
    nicknames[socket.id] = "guest_" + guestnumber;
    console.log(nicknames);
    socket.on("message", function(data){
      console.log("recieving: " + data);
      io.sockets.emit('message', data)
    });

    socket.on('nicknameChangeRequest', function(name){
      changeNickname(name, socket);
    });

    socket.on('disconnect', function() {
      io.sockets.emit("message", nicknames[socket.id] + " has left the room!!");
      delete nicknames[socket.id];
    })
  };

  io.sockets.on('connection', connectionCallBack);
};


module.exports = createChat;
