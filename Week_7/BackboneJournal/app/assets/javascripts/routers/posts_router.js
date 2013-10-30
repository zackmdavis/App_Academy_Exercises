BackboneJournal.Routers.PostsRouter = Backbone.Router.extend({

  initialize: function($root, $sidebar, posts) {
    this.$root = $root;
    this.$sidebar = $sidebar;
    this.posts = posts;
  },

  routes: {
    "": "index",
    "new": "newPost",
    ":id": "show"
  },

  index: function() {
    var that = this;

    var postsIndexView = new BackboneJournal.Views.PostsIndexView({
      collection: that.posts
    })

    that.$sidebar.html(postsIndexView.render().$el);
  },


  newPost: function() {
    var that = this;

    var newPost = new BackboneJournal.Models.Post();
    var newPostView = new BackboneJournal.Views.NewPostView({
      collection: that.posts
    });


    that.$root.html(newPostView.render().$el);
  },

  show: function(post_id) {
    var that = this;
    var postShowView = new BackboneJournal.Views.PostShowView({
      model: that.posts.findWhere({id: parseInt(post_id)})
    })

    that.$root.html(postShowView.render().$el);
  }

})