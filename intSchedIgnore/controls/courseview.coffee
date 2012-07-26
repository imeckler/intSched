class CourseView extends Completable
    inherited:
        draggable:
            start: (event, ui) ->
                console.log "poopies drag"
            revert: 'invalid'
            appendTo: 'body'

    title: Control.chain 'content'

I.CourseView = CourseView
