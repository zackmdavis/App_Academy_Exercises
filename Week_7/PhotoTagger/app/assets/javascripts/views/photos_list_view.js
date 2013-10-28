(function(root){

  var PhotosListView = root.PhotosListView = function() {
    this.$el = $("<div>")
  }

  PhotosListView.prototype.render = function() {
    this.$el.empty();
    this.$el.append("<ul>");
    console.log("RAH RAH");

    console.log(Photo.all.length);
    for(var i = 0; i < Photo.all.length; i++) {
      console.log("ul in docuemnt??", $('ul'));
      $('ul').append("<li>"+Photo.all[i].attributes.title+"</li>");
    }

    return this;
  }

})(this);