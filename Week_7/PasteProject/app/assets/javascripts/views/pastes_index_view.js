PasteProject.Views.PastesIndexView = Backbone.View.extend({

  events: {},

  template: JST['pastes_index_view'],

  render: function(){
    var renderedContent = this.template({
      pastes: this.collection
    });
    this.$el.html(renderedContent);

    return this;
  },

});