PasteProject.Views.PastesIndexView = Backbone.View.extend({

  events: {},

  template: JST['paste_show_view'],

  render: function(){
    var renderedContent = this.template({
      paste: this.model
    });
    this.$el.html(renderedContent);

    return this;
  },

});