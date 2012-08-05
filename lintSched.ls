<- whenClient

LCourses.remove!

for course in fullCourseList
  LCourses.insert course

qs = 
  * season: \Autumn
  * season: \Winter
  * season: \Spring
  * season: \Summer

Template.schedule.years = [quarters: qs, num: i for i in [1 to 4]]

Template.majorbin.selected_major = ->
  Majors.findOne  \name : Session.get \selected_major_name

Session.set \selected_major_name , \CMSC

Template.bin.events =
  'click .heading' : (e) ->
    heading = $ e.target
    content = heading.next!
    collapsed = content.data \collapsed
    display = if collapsed then \show else \hide
    content.animate \height : display , \fast , null , ->
      content.data \collapsed, not collapsed

  'mouseover .singleton_bin' : (e) ->
    course = $ e.target
    if not course.data \obj
      obj = LCourses.findOne \code : course.text!trim!
      course.data \obj, obj
      course.popover do
        title: obj.title
        content: obj.desc
        placement: \left
      course.draggable do
        revert: \invalid
        helper: \clone
        appendTo: \body

<- Meteor.defer
/*
majorinput = $ '.majorinput'
majorinput.typeahead do
  source: map (.bin.title), Majors.find!fetch!
majorinput.on do
  change: -> Session.set \selected_major_name , @value

for course in $ '.singleton_bin'
  course = $ course
  obj = LCourses.findOne \code : course.text!trim!
  course.data \obj, obj

  course.popover do
    title: obj.title
    content: obj.desc
    placement: \left

  course.draggable do
    revert: \invalid
    helper: \clone
    appendTo: \body
*/

$ '.quarter' .droppable do
  accept: (course) ->
    ($ @ .attr 'season') in course.data 'obj' .terms_offered

  activate: (event, ui) ->
    $ @ .animate 'background-color': \#93FF93

  deactivate: (event, ui) ->
    $ @ .animate 'background-color': \#EEE
