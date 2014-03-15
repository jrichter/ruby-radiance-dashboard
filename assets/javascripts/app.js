$(function(){
window.DoseModel = Backbone.Model.extend({
  //This is for a single item.  I don't need this.
});

window.DoseList = Backbone.Collection.extend({
  model: DoseModel,
  url: '/tests',
  initialize: function(){
  }
});

window.AppView = Backbone.View.extend({
  el: '#content',
  initialize: function(){
    doseList = new DoseList();
    doseList.on('all', this.render, this);
    doseList.reset([
                   {accessionNumber: "12345"},
                   {accessionNumber: "67890"},
                   {accessionNumber: "24680"}
    ]);
    doseList.fetch();
  },
  render: function(){
    this.$el.html('<ul>');
    doseList.each(function(model){this.$el.append('<li>' + model.attributes.accessionNumber + '</li>');},this);
    this.$el.append('</ul>');
  }
});
window.App = new AppView();
});
