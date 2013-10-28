(function(root){

  var PhotosListView = root.PhotosListView = function() {
    this.$el = $("<div>")
  }

  PhotosListView.prototype.render = function() {
    this.$el.empty();
    this.$el.append("<ul>");

    for(var i = 0; i < Photo.all.length; i++) {
      $('ul').append("<li>"+Photo.all[i].attributes.title+"</li>");
    }

    return this;
  }

})(this);