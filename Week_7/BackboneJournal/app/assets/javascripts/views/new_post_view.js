BackboneJournal.Views.NewPostView = Backbone.View.extend({
  events: {
    "click #submit-button": "submit"
  },

  render: function() {
    var that = this;
    var renderedContent = JST["templates/post_form"]();
    that.$el.html(renderedContent);
    return that;
  },

  submit: function(event) {
    var that = this;
    event.preventDefault();

    var formTitle = $("#title").val();
    var formBody = $("#body").val();

    var newPost = new BackboneJournal.Models.Post({title: formTitle, body: formBody});
    this.collection.create(newPost);
    Backbone.history.navigate('/', {trigger: true});
  }


})