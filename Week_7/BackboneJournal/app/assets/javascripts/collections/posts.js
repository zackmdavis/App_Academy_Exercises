window.BackboneJournal.Posts = Backbone.Collection.extend({
  model: BackboneJournal.Post,
  url: "/posts"
})