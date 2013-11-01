NewsReader.Views.FeedsIndexView = Backbone.View.extend({

  events: {},

  template: JST['feeds_index_view'],

  render: function() {
    var renderedContent = this.template({
      feeds: this.collection
    });
    this.$el.html(renderedContent);
    return this;
  }

});