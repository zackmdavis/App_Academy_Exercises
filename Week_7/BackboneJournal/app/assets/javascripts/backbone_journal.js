window.BackboneJournal = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},
  initialize: function($root, posts) {
    var postIndexView = new BackboneJournal.Views.PostsIndexView({
      collection: posts
    });
    // TODO: the following listenTo calls should really be in the view file itself
    postIndexView.listenTo(posts, "add", postIndexView.render);
    postIndexView.listenTo(posts, "remove", postIndexView.render);
    postIndexView.listenTo(posts, "change:title", postIndexView.render);
    postIndexView.listenTo(posts, "reset", postIndexView.render);
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
      var thePosts = new BackboneJournal.Posts(postsJson);
      BackboneJournal.initialize($('#index-content'), thePosts);
    }
  })
});
