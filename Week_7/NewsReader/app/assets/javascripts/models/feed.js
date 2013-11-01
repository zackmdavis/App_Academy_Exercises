NewsReader.Models.Feed = Backbone.Model.extend({
  url: function() {
    return '/feeds/' + this.id + '/entries';
  }

});