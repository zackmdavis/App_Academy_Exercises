window.BackboneJournal = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},
  initialize: function($root, posts) {
    var postIndexView = new BackboneJournal.Views.PostsIndexView({
      collection: posts
    });
    $root.html(postIndexView.render().$el);

    new BackboneJournal.Routers.PostsRouter($root, posts);
    Backbone.history.start();

  }
};

$(document).ready(function(){
  $.ajax({
    type: "GET",
    url: "/posts.json",
    success: function(postsJson) {
      var thePosts = new BackboneJournal.Collections.Posts(postsJson);
      BackboneJournal.initialize($('#index-content'), thePosts);
    }
  })
});
