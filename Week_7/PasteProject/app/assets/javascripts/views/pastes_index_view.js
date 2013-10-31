PasteProject.Views.PastesIndexView = Backbone.View.extend({

  events: {},

  template: JST['pastes_index_view'],

  showTemplate: JST['paste_show_view'],

  render: function(){
    var that = this;
    var show_partials = [];
    console.log(this.collection);
    this.collection.forEach(function(paste) {
      var partial = that.showTemplate({
        paste: paste
      });
      show_partials.push(partial);
    });
    console.log(show_partials);
    var renderedContent = this.template({
      pastePartials: show_partials
    })

    // var renderedContent = this.template({
 //      pastes: this.collection
 //    });
    this.$el.html(renderedContent);

    return this;
  },

});