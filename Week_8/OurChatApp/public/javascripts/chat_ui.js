(function(root) {

  var Chat = root.Chat = (root.Chat || {})

  var getMessage = Chat.getMessage = function(chatSocket) {

    var message = $('#message-field').val();
    chatSocket.sendMessage(message);
  }

  var displayMessage = Chat.displayMessage = function(message) {
    $('#messages').append(message + "<br>");
  }

  $(document).ready(function(){
    var ourSocket = io.connect("http://10.0.1.21:8080");
    ourSocket.on("message", displayMessage);
    ourSocket.on("nicknameChangeResult", function(result) {
      displayMessage(result.message);
    })
    var ourChatSocket = new Chat.chatSocket(ourSocket);

    $('#send-messages').on("submit", function(event) {
      event.preventDefault();
      getMessage(ourChatSocket);
    });
  })

})(this);