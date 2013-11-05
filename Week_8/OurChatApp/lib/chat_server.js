var createChat = function(server){
  var io = require('socket.io').listen(server);
  var guestnumber = 0;
  var nicknames = {};
  var namesUsed = {};
  var currentRooms = {};

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
    joinRoom(socket, "The Lobby");

    socket.on("message", function(data){
      var room = currentRooms[socket.id][0];
      var data = "<span style='color: #33AB45;'>[" + room + "]</span> <span style='font-weight: bold; color: #A32352'>" + nicknames[socket.id] + "</span>: " + data
      io.sockets.in(room).emit('message', data)
    });

    socket.on('nicknameChangeRequest', function(name){
      changeNickname(name, socket);
    });

    socket.on('disconnect', function() {
      io.sockets.emit("message", nicknames[socket.id] + " has left the room!!");
      delete nicknames[socket.id];
      updateUsers();
    });

    socket.on('roomChangeRequest', function(roomName){
      handleRoomChangeRequests(socket, roomName)
    });
  };

  var handleRoomChangeRequests = function(socket, roomName){
    joinRoom(socket, roomName);
    leaveRoom( socket, currentRooms[socket.id][0] )
  };

  var joinRoom = function(socket, roomName) {
    if (!currentRooms[socket.id]) {
      currentRooms[socket.id] = [];
    }
    currentRooms[socket.id].push(roomName);
    socket.join(roomName);
    io.sockets.in(roomName).emit('message', nicknames[socket.id] + " joined " + roomName);

    socket.emit('roomChange', roomName)
  };

  var leaveRoom = function(socket, roomName) {
    var socketRooms = currentRooms[socket.id];
    var roomIndex = socketRooms.indexOf(roomName);
    socket.leave(roomName);
    socketRooms.splice(roomIndex, 1);
  };

  io.sockets.on('connection', connectionCallBack);
};


module.exports = createChat;
