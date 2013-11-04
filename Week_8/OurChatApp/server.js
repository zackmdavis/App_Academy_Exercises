var http = require('http');
var fs = require('fs');
var path = require('path');
var mime = require('mime');
var chat_server = require('./lib/chat_server.js')
// var router = require('./router.js');

var server = http.createServer(function (request, response) {
  var router = new Router(request, response);
  router.process();
}).listen(8080);

chat_server(server);


var Router = function(req, res){
  this.req = req;
  this.res = res;
};

Router.prototype.process = function(){
  var path = this.req.url;

  var router = this;

  var fileCallback = function(err, data){
    if (err){
      router.res.writeHead(404)
      console.log(router.res.statusCode);
      router.res.end();
    } else {
      if (path.slice(-2) === 'js' ){
        router.res.writeHead(200, {'Content-Type': 'text/javascript'});
      } else {
        router.res.writeHead(200, {'Content-Type': 'text/html'});
      }
      router.res.write(data);
      router.res.end();
    }
  };

  if (path === '/'){
    fs.readFile('public/index.html', fileCallback);
  } else {
    fs.readFile(path.slice(1), fileCallback);
  }
};

