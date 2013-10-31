PasteProject.Views.PastesIndexView = Backbone.View.extend({

  events: {
    "click .favorite-button": "makeFavorite"
  },

  template: JST['pastes_index_view'],

  showTemplate: JST['paste_show_view'],

  render: function(){
    var that = this;
    var show_partials = [];
    this.collection.forEach(function(paste) {
      var partial = that.showTemplate({
        paste: paste
      });
      show_partials.push(partial);
    });
    var renderedContent = this.template({
      pastePartials: show_partials
    })
    this.$el.html(renderedContent);

    return this;
  },

  makeFavorite: function(event) {
    var clicked = $(event.currentTarget);
    clicked.text("Unfavorite");
    var paste_id = clicked.data("id");
    var paste = this.collection.findWhere({id: paste_id});
    var favorite = new PasteProject.Models.Favorite({});
    favorite.set({ paste_id: paste.id, user_id: paste.attributes.owner_id });
    favorite.save();
  },

});