(function(root) {

  var Chat = root.Chat = (root.Chat || {})

  var getMessage = Chat.getMessage = function(chatSocket) {

    var message = $('#message-field').val();
    chatSocket.sendMessage(message);
    $('#message-field').val('');
  }

  var displayMessage = Chat.displayMessage = function(message) {
    $('#messages').append(message + "<br>");
  }

  var displayUsers = Chat.displayUsers = function(users){
    var list = $('#users').find($('ul'))
    list.html('');
    users.forEach(function(user){
      list.append("<li>" + user + "</li>")
    });
  }

  $(document).ready(function(){
    var ourSocket = io.connect("http://10.0.1.21:8080");
    ourSocket.on("message", displayMessage);

    ourSocket.on("updatedUsers", displayUsers);

    ourSocket.on("nicknameChangeResult", function(result) {
      displayMessage(result.message);
      console.log(result)
      displayUsers(result.nicknames)
    })
    var ourChatSocket = new Chat.chatSocket(ourSocket);

    ourSocket.on('roomChange', function(roomName){
      ourSocket.room = roomName;
    });


    $('#send-messages').on("submit", function(event) {
      event.preventDefault();
      getMessage(ourChatSocket);


    });
  })

})(this);