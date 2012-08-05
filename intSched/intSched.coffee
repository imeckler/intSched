if Meteor.is_client
  Meteor.subscribe 'majors'
  Meteor.subscribe 'courses'

  # $(document).ready ->
  #   su = ScheduleUI.create!
  #   $('body').append su
  #   su.$listComboBox!.items map ((x) -> x.name), I.collections.majors.find!.fetch!
  #   window.su = su

if Meteor.is_server
  Meteor.startup ->
    if not I.collections.courses.findOne!
      I.collections.courses.insert course for course in fullcourselist
