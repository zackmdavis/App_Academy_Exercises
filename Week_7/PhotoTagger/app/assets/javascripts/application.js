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

  var Photo = root.Photo = function(attributes) {
    this.attributes = attributes
  }

  Photo.all = [];

  Photo.ensure_in_all = function(photo) {
    var included = false;
    for(var i = 0; i < Photo.all.length; i++) {
      if(Photo.all[i].attributes.id === photo.attributes.id) {
        included = true;
      }
    }
    if(!included) {
      Photo.all.push(photo);
    }
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
    var that = this;
    $.ajax({
      type: "POST",
      url: "/api/photos",
      data: that.attributes,
      success: function(response) {
        callback(response);
        _.extend(that.attributes, response);
        Photo.ensure_in_all(that);
      }
    })
  }

  Photo.fetchByUserId = function(userId, callback) {
    var photos = [];
    $.ajax({
      type: "GET",
      url: "/api/users/" + userId + "/photos",
      success: function(response) {
        response.forEach(function(photoJson) {
          var photo = new Photo(photoJson);
          photos.push(photo);
          Photo.ensure_in_all(photo);
        })
        callback(photos);
      }
    });
  }

})(this);