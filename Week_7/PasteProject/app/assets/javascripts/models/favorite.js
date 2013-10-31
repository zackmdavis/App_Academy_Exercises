PasteProject.Models.Favorite = Backbone.Model.extend({

  urlRoot: function() {
    return   "/pastes/" + this.get("paste_id") +"/favorite";
  }

});