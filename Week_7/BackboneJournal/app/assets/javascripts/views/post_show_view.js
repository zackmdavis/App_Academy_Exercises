BackboneJournal.Views.PostShowView = Backbone.View.extend({

  render: function() {
    var show = $('<div id="post-show"></div>');
    var h3 = $('<h3></h3>').text(this.model.get("title"));
    var body = $('<div="post-body"><div>').html(this.model.get("body"));
    body.append('<br><br><a href="/">back to index</a>');
    show.append(h3);
    show.append(body);
    this.$el.html(show);
    return this;
  },

});


