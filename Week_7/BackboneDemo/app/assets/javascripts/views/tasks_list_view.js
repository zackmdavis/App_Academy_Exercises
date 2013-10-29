// to make a particular view, we're (effectively) "subclassing"
// Backbone.View with "extend"
TD.Views.TasksListView = Backbone.View.extend({
  render: function () {
    var that = this;
    // make an unordered list
    var ul = $("<ul></ul>");

    // for each element in collection, execute the following function with
    // argument _task_
    _(that.collection.models).each(function (task) {
      // append the jQuery list item with the task title
      ul.append(
        $("<li></li>").text(task.get("title"))
      )
    });

    that.$el.html(ul);
    return that;
  }
});
