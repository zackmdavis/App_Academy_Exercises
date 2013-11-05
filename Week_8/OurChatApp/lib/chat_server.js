var createChat = function(server){
  var io = require('socket.io').listen(server);
  var guestnumber = 0;
  var nicknames = {};
  var namesUsed = {};

  var isValidNickname = function(name){
    return (name.slice(0,5) !== 'guest' && !namesUsed[name])
  };

  var currentNicknames = function() {
    var names = [];
    for (name in nicknames) {
      names.push(nicknames[name]);
    }
    return names;
  }

  var changeNickname = function(name, socket){
    console.log("name" + name)
    if(isValidNickname(name)){
      namesUsed[name] = true;
      var oldName = nicknames[socket.id];
      nicknames[socket.id] = name;
      io.sockets.emit('nicknameChangeResult', {
        success: true,
        message: oldName + " changed name to " + name})
      updateUsers();
    } else {
      socket.emit('nicknameChangeResult', {
        success: false,
        message: "Don't be silly"});
    }
  };

  var updateUsers = function(){
    io.sockets.emit( 'updatedUsers', currentNicknames() )
  };


  var connectionCallBack = function(socket){
    guestnumber++;
    nicknames[socket.id] = "guest_" + guestnumber;

    updateUsers();

    socket.on("message", function(data){
      console.log("recieving: " + data);
      data = nicknames[socket.id] + ": " + data
      io.sockets.emit('message', data)
    });

    io.sockets.emit('message', nicknames[socket.id] + " joined the room.")

    socket.on('nicknameChangeRequest', function(name){
      changeNickname(name, socket);
    });

    socket.on('disconnect', function() {
      io.sockets.emit("message", nicknames[socket.id] + " has left the room!!");
      delete nicknames[socket.id];
      updateUsers();
    });
  };

  io.sockets.on('connection', connectionCallBack);
};


module.exports = createChat;
