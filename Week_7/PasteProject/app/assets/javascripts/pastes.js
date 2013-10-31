window.PasteProject = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},
  initialize: function() {
    PasteProject.pastes = new PasteProject.Collections.Pastes();
    new PasteProject.Routers.Pastes({
      "$root": $("#content")
    });
    Backbone.history.start();
  }
};

$(document).ready(function(){
  PasteProject.initialize();
});