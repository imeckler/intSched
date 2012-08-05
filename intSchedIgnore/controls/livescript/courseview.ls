class CourseView extends Completable
  -> return Completable.apply this, arguments

  inherited:
    draggable:
      start: (event, ui) -> console.log  'poopies drag'
      revert: 'invalid'
      helper: 'clone'
      appendTo: 'body'

  title: Control.chain 'content'

I.CourseView = CourseView
