BackboneJournal.Views.PostShowView = Backbone.View.extend({

  events: {
    "dblclick #title": "hotEditTitle",
    "dblclick #body": "hotEditBody",
    "blur #edit-title-field": "hotSaveTitle",
    "blur #edit-body-field": "hotSaveBody"
  },

  render: function() {

    var show = $('<div id="post-show"></div>');
    var h3 = $('<h3 id="title"></h3>').text(this.model.get("title"));
    var body = $('<div="post-body" id="body"><div>').html(this.model.get("body"));
    show.append(h3);
    show.append(body);
    this.$el.html(show);
    return this;
  },

  hotEditTitle: function() {
    $('#title').replaceWith('<input id="edit-title-field" name="title" type="text" placeholder="edit title"><br>');
  },

  hotEditBody: function() {
    $('#body').replaceWith('<textarea id="edit-body-field" name="body" rows="15" cols="45" placeholder="edit the body of the post"></textarea>')
  },

  hotSaveTitle: function() {
    $("#edit-title-field").replaceWith($("<h3 id='title'></h3>").text($("#edit-title-field").val()));
  },

  hotSaveBody: function() {
    var newBodyText = $("#edit-body-field").val();
    newBodyText = newBodyText.replace(/\n/g, '<br>')
    var newBody = $("<div id='body'></div").html(newBodyText);
    $("#edit-body-field").replaceWith(newBody);
  }

});


