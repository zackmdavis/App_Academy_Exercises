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