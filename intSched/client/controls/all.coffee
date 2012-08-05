I.controls = {}

class Completable extends Control
    numNeeded: Control.property!

    title: Control.property!

    # The list of events to watch for. Should only be set on creation
    watchList: Control.property (watchList) ->
        @off!
        (@on e, (ev) => @_numComplete(@_numComplete! + 1)) for e in @watchList!

    complete: Control.property.bool(
        (complete) ->
            if complete
                @trigger @title!.replace ' ', '_',
        false)

    _numComplete: Control.property(
        (numComplete) -> if numComplete == @numNeeded! then @complete(true),
        0)

    initialize: ->
        if not @watchList! then return
        @off!
        (@on e, (ev) => @_numComplete(@_numComplete! + 1)) for e in @watchList!

I.controls.Completable = Completable

class BinView extends Completable
    inherited:
        content:
            control: CollapsibleWithHeadingButton
            ref: "collapsible"

    ## Until I figure out how to add a sideEffectFunction properly
    complete: (complete) ->
        if complete is undefined
            return @_super!
        else
            @_super complete
            if complete
                @css
                    "background-color": "#93FF93"
            else
                @css
                    "background-color": "white"

    number: Control.property!

    binList: Control.property (binList) ->
        @$collapsible!.content binList

    obj: Control.property!

    title: Control.chain '$collapsible', 'heading'

I.controls.BinView = BinView

class CourseView extends Completable
    inherited:
        css:
            'cursor': 'pointer'

    title: Control.chain 'content'

    _courseObj: Control.property!

    currentOwner: Control.property!

    termsOffered: Control.property!

    initialize: ->
        @draggable
            start: (event, ui) =>
                if not @_courseObj!
                    @_courseObj I.collections.courses.findOne 'code': @title! 
            revert: 'invalid'
            helper: 'clone'
            appendTo: 'body'

class CourseHolder extends Control
    inherited:
        content: [
            {
                control: CourseView
                ref: 'courseView'
            }
            {
                control: PopupButton
                ref: 'infoButton'
            }
        ]

    title: Control.chain '$courseView', 'title'

    termsOffered: Control.chain '$courseView', 'termsOffered'

    info: Control.chain '$infoButton', 'popup'

    numNeeded: Control.chain '$courseView', 'numNeeded'

I.CourseView = CourseView

objToView = (obj) ->
    if typeof obj == 'string'
        course = I.collections.courses.findOne 'code': obj
        CourseHolder.create!.json
            title: obj
            info: course.desc
            termsOffered: course.terms_offered
            numNeeded: 1
    else
        BinView.create!.json
            numNeeded: obj.num
            obj: obj
            title: obj.title
            binList:
                control: List
                items: map objToView, obj.list
            watchList: ((o.title || o).replace ' ', '_' for o in obj.list)

I.objToView = objToView

class MajorView extends BinView
    _obj: Control.property (obj) ->
        @content objToView obj.bin

    name: Control.property (name) ->
        # Should check if the new name is different from the old one.
        # Consider adding Liron's sideEffectFn patch
        @_obj I.collections.majors.findOne 'name': name

    initialize: ->
        if not @_obj! and @name!
            @_obj I.collections.majors.find('name': @name!).fetch!
            @content objToView @_obj!.bin

I.controls.MajorView = MajorView

### Schedule Views follow ###

class QuarterView extends Control
    inherited:
        content:
            control: List
            ref: "courseViews"

        css:
            'width': '150px'
            'height': '150px'
            'border-right': '2px solid black'
            'border-top': '2px solid black'
            'background-color': 'white'

    _shouldAccept: Control.property.bool!

    season: Control.property!

    # Find out why .title! isn't working here. .text! is a hack.
    object: -> $(c).control!.title! for c in @$courseViews!.controls!

    initialize: ->
        @droppable
            accept: (draggable) =>
                course = draggable.control!
                if -1 isnt course.termsOffered!.indexOf @season!
                    @_shouldAccept true

            activate: (event, ui) =>
                course = ui.draggable.control!
                if @_shouldAccept!
                    @animate
                        'background-color': '#93FF93'

            deactivate: =>
                @animate
                    'background-color': 'white'

            drop: (event, ui) =>
                newCourse = ui.draggable.control!
                # if newcourse is valid...
                newCourse.complete true
                @$courseViews!.insertItemBefore newCourse, 0

    tag: 'td'


class YearView extends Control
    object: ->
        $(q).control!.object! for q in @$quarterViews!.controls!

    inherited:
        content:
            control: List
            ref: 'quarterViews'
            itemClass: QuarterView
            mapFunction: 'season'
            items: ["Autumn", "Winter", "Spring", "Summer"]

    name: Control.property!

    tag: 'tr'


class ScheduleView extends Control
    object: ->
        $(y).control!.object! for y in @$yearViews!.controls!

    inherited:
        content:
            control: List
            itemClass: YearView
            ref: 'yearViews'
            mapFunction:
                name: 'name'
            items: ["1", "2", "3", "4"]

        css:
            'border-left': '2px solid black'
            'border-bottom': '2px solid black'
            'border-spacing': '0px'
            'font-family': 'Helvetica, Arial, sans'

    # This will correspond to a meteor cursor or something similar
    years: Control.property!

    tag: 'table'

class ScheduleUI extends Control
    inherited:
        content:
            control: HorizontalPanels
            left:
                control: ScheduleView
                ref: 'scheduleView'
            right:
                html: 'div'
                content: [
                    {
                        control: ListComboBox
                        ref: 'listComboBox'
                        css:
                            'width': 'inherit'
                    }
                    {
                        control: MajorView
                        ref: 'majorView'
                    }
                ]
                css:
                    'width': '300px'
        css:
            'width': '900px'
            'height': '700px'

    initialize: ->
        @majorList!.on
            selectionChanged: =>
                selectedControl = @majorList!.selectedControl!
                if selectedControl
                    content = selectedControl.content!
                    if content is not @content!
                        @content content
                        @_selectText 0, content.length

                @$majorView!.name content

    majorList: Control.chain '$listComboBox', '$list'
