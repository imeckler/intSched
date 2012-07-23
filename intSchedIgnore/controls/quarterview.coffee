class QuarterView extends Control
    inherited:
        content:
            control: List
            itemClass: CourseView
            ref: "courseViews"

        css:
            'width': '150px'
            'height': '150px'
            'border-right': '2px solid black'
            'border-top': '2px solid black'
            'background-color': 'gray'

    season: Control.property()

    initialize: ->
        @droppable
            accept: ".CourseView"

            activate: ->

            deactivate: =>
                @css
                    'background-color': 'gray'

            drop: (event, ui) =>
                newCourse = ui.helper.control()
                @courseViews().insertItemBefore newCourse, 0

    tag: 'td'
