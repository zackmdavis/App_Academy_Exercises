PasteProject.Routers.Pastes = Backbone.Router.extend({

  initialize: function(options) {
    this.$root = options.$root
  },

  routes: {
    "": "index",
    "new": "new"
  },

  index: function() {
    var that = this;

    PasteProject.pastes.fetch({
      success: function() {
        var pastesIndexView = new PasteProject.Views.PastesIndexView({
          collection: PasteProject.pastes
        });

        that.$root.html(pastesIndexView.render().$el);
      }
    })
  },

  new: function () {
    var pasteFormView = new PasteProject.Views.PasteFormView({});
    this.$root.html(pasteFormView.render().$el);
  },
})