(function(root){

  var PhotosListView = root.PhotosListView = function() {
    this.$el = $("<div>");
    root.Photo.on("add", this.render.bind(this));
  }

  PhotosListView.prototype.render = function() {

    this.$el.empty();
    // this.$el.detach("ul");
    this.$el.append("<ul>")
    console.log(Photo.all.length)
    for(var i = 0; i < Photo.all.length; i++) {
      $('ul').append("<li>"+Photo.all[i].attributes.title+"</li>");
    }

    return this;
  }

  // PhotosListView.prototype.renderNewPhoto = function() {
 //    console.log("hello from renderNewPhoto; I remain, Your faithful corrspohdehtj, Console Log")
 //    $(this.$el.children()[0]).append("<li>"+ Photo.all[Photo.all.length-1].attributes.title+"</li>");
 //  }

})(this);