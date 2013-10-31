PasteProject.Collections.Pastes = Backbone.Collection.extend({
  model: PasteProject.Models.Paste,
  url: "/pastes"
});