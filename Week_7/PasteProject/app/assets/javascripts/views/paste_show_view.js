PasteProject.Views.PasteShowView = Backbone.View.extend({

  events: {
    "click .favorite-button": "makeFavorite"
  },

  template: JST['paste_show_view'],

  render: function(){
    var renderedContent = this.template({
      paste: this.model
    });
    this.$el.html(renderedContent);

    return this;
  },

  makeFavorite: function(event) {
    console.log('rah')
    var clicked = event.currentTarget;
    console.log(clicked);
  },

});