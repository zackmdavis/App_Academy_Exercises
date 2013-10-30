window.BackboneJournal.Collections.Posts = Backbone.Collection.extend({
  model: BackboneJournal.Models.Post,
  url: "/posts"
})