PasteProject.Models.Paste = Backbone.Model.extend({
  urlRoot: "/pastes",

  favorite: function() {
    if (!this._favorite) {
      this._favorite = [];
    }
    return this._favorite
  },

  parse: function(serverAttributes) {
    this.favorite()[0] = serverAttributes.favorite;
    delete serverAttributes.favorite;

    return serverAttributes
  },

  // maybe override later
  // toJSON: function () {
  //
  // }

});