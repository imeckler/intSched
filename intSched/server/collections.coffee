Meteor.publish "majors", ->
    I.collections.majors.find {}

Meteor.publish "courses", ->
    I.collections.courses.find {}