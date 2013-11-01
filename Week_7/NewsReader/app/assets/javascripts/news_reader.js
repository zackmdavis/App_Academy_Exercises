window.NewsReader = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},
  initialize: function() {
    NewsReader.feeds = new NewsReader.Collections.Feeds();
    new NewsReader.Routers.Router({
      "$root": $('#content')
    });
    Backbone.history.start();
  }
};

$(document).ready(function(){
  //debugger;
  NewsReader.initialize();
});
