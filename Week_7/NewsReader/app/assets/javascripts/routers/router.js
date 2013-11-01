NewsReader.Routers.Router = Backbone.Router.extend({

  initialize: function(options){
    this.$root = options.$root;
  },

  routes: {
    "": "index",
    ":id": "show"
  },

  index: function() {
    var that = this;
    NewsReader.feeds.fetch({
      success: function() {
        var feedsIndexView = new NewsReader.Views.FeedsIndexView({
          collection: NewsReader.feeds
        });
        that.$root.html(feedsIndexView.render().$el);
      }
    });
  },

  show: function(id) {
    var that = this;
    var feed = new NewsReader.Models.Feed({id: id});
    feed.fetch({
      success: function() {
        var feedShowView = new NewsReader.Views.FeedShowView({
          model: feed
        });
        that.$root.html(feedShowView.render().$el);
      }
    });
  }

})