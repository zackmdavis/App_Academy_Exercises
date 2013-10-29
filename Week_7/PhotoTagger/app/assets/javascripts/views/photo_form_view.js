(function(root){

  var PhotoFormView = root.PhotoFormView = function(){
    this.$el = $("<div>");
    $('#form-holder').on("click", "#create-button", this.submit); //this.submit);
  }

  PhotoFormView.prototype.render = function() {
    this.$el.empty();

    var jst = JST["photo_form"]();
    this.$el.html(jst);
    return this;
  }

  PhotoFormView.prototype.submit = function(event) {
    event.preventDefault();
    var newPhoto = new Photo({});
    var serializedPhoto = $('#photo-form').serializeJSON();
    newPhoto.attributes.owner_id = CURRENT_USER_ID;
    newPhoto.attributes.url = serializedPhoto["photo"]["url"];
    newPhoto.attributes.title = serializedPhoto["photo"]["title"];

    newPhoto.create(function() {});
  }


})(this);