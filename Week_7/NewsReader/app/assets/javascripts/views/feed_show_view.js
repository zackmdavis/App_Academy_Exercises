NewsReader.Views.FeedShowView = Backbone.View.extend({

  events: {},

  template: JST['feed_show_view'],

  render: function() {
    globalFeed = this.model;
    var renderedContent = this.template({
      feed: this.model
    });
    this.$el.html(renderedContent);
    return this;
  }

});