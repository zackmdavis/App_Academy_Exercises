BackboneJournal.Routers.PostsRouter = Backbone.Router.extend({
  initialize: function($root, posts) {
    this.$root = $root;
    this.posts = posts;
  },

  routes: {
    "": "index",
    ":id": "show"
  },

  index: function() {
    var that = this;

    var postsIndexView = new BackboneJournal.Views.PostsIndexView({
      collection: that.posts;
    })

    that.$root.html(postsIndexView.render().$el);
  },

  show: function(post_id) {
    var that = this;

    var postShowView = new BackboneJournal.Views.PostShowView({
      model: that.posts.findWhere({id: post_id});
    })

    that.$root.html(postShowView.render().$el);
  },

})