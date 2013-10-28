(function(root){

  var PhotoFormView = root.PhotoFormView = function(){
    this.$el = $("<div>");
  }

  PhotoFormView.prototype.render = function() {
    this.$el.empty();

    var jst = JST["photo_form"]();
    this.$el.append(jst);
    return this;
  }


})(this);