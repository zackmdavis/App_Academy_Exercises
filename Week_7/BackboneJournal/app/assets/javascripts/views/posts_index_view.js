BackboneJournal.Views.PostsIndexView = Backbone.View.extend({

  render: function() {
    var ul = $('<ul></ul>');
    _(this.collection.models).each(function (post) {
      var titlePoint = $("<li></li>").text(post.get("title"));
      ul.append(titlePoint);
      var deletionButton = $("<button class='deletion-button' data-id='"+ post.id +"'>delete</button>");
      titlePoint.append(deletionButton);
    });
    this.$el.html(ul);
    return this;
  },

  events: { "click .deletion-button": "deletePost" },

  deletePost: function(event) {
    var idToDelete = parseInt($(event.target).data("id"));
    var toRemove = this.collection.where({id: idToDelete});
    this.collection.remove(toRemove);
  }

});


