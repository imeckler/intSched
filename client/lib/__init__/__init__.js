I = {};

// Local collections, used to speed things up
LCourses = new Meteor.Collection(null);

// Handlebars helpers
Handlebars.registerHelper("each_with_index", function(array, fn) {
  var buffer = "";
  for (var i = 0, j = array.length; i < j; i++) {
    var item = array[i];

    // stick an index property onto the item, starting with 1, may make configurable later
    item.index = i+1;

    // show the inside of the block
    buffer += fn(item);
  }

  // return the finished buffer
  return buffer;

});

var _i = 0;

Handlebars.registerHelper('logger', function(options) {
  console.log(_i, this);
  _i += 1;
  return options.fn(this);
});