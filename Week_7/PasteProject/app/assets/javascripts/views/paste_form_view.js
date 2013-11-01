PasteProject.Views.PasteFormView = Backbone.View.extend({

  events: {
    "submit .new_paste": "submit"
  },

  template: JST['paste_form_view'],

  render: function () {
    var renderedContent = this.template({});
    this.$el.html(renderedContent);
    return this;
  },

  submit: function (event) {
    event.preventDefault();
    var newPaste = $(event.currentTarget).serializeJSON();
    newPaste["paste"]["body"] = newPaste["paste"]["body"].replace(/\n/g, "<br>");
    var newPasteModel = new PasteProject.Models.Paste(newPaste.paste, {parse: true});

    newPasteModel.save({}, {
      success: function(){
        Backbone.history.navigate("", { trigger: true });
      }
    });
  },


});