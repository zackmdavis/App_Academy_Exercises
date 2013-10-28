// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require underscore
//= require jquery
//= require jquery_ujs
//= require_tree .

(function(root){

  var Photo = root.photo = function(attributes) {
    this.attributes = attributes
  }

  Photo.prototype.get = function(attr_name) {
    return this.attributes[attr_name];
  }

  Photo.prototype.set = function(attr_name, value) {
    this.attributes[attr_name] = value;
  }

  Photo.prototype.update = function(updated_attributes) {
    _.extend(this.attributes, updated_attributes);
  }

  Photo.prototype.create = function(callback) {
    $.ajax({
      type: "POST",
      url: "/api/photos",
      data: this.attributes,
      success: callback
    })
  }

  Photo.prototype.fetchByUserId = function(userId, callback) {
    // TODO
  }

})(this);