I.controls = {}

class Completable extends Control
    numNeeded: Control.property()

    title: Control.property()

    # The list of events to watch for. Should only be set on creation
    watchList: Control.property (watchList) ->
        @off()
        (@on e, (ev) => @_numComplete(@_numComplete() + 1)) for e in @watchList()

    complete: Control.property.bool(
        (complete) ->
            if complete
                @trigger @title().replace ' ', '_',
        false)

    _numComplete: Control.property(
        (numComplete) -> if numComplete == @numNeeded() then @complete(true),
        0)

    initialize: ->
        if not @watchList()
            return
        @off()
        (@on e, (ev) => @_numComplete(@_numComplete() + 1)) for e in @watchList()

I.controls.Completable = Completable

class BinView extends Completable
    inherited:
        content:
            control: CollapsibleWithHeadingButton
            ref: "collapsible"

    ## Until I figure out how to add a sideEffectFunction properly
    complete: (complete) ->
        if complete is undefined
            return @_super()
        else
            @_super complete
            if complete
                @css
                    "background-color": "green"
            else
                @css
                    "background-color": "white"

    number: Control.property()

    binList: Control.property (binList) ->
        @$collapsible().content binList

    obj: Control.property()

    title: Control.chain '$collapsible', 'heading'

I.controls.BinView = BinView

class CourseView extends Completable
    inherited:
        draggable:
            start: (event, ui) ->
                console.log "poopies drag"
            revert: 'invalid'
            appendTo: 'body'

    title: Control.chain 'content'

I.CourseView = CourseView

objToView = (obj) ->
    if typeof obj == 'string'
        CourseView.create().json
            title: obj
            numNeeded: 1
    else
        BinView.create().json
            numNeeded: obj.num
            obj: obj
            title: obj.title
            binList:
                control: List
                items: objToView o for o in obj.list
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
        if not @_obj() and @name()
            @_obj I.collections.majors.find('name': @name()).fetch()
            @content objToView @_obj().bin

I.controls.MajorView = MajorView

### Schedule Views follow ###

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
            'background-color': 'white'

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


class YearView extends Control
    inherited:
        content:
            control: List
            itemClass: QuarterView
            mapFunction: 'season'
            items: ["Autumn", "Winter", "Spring", "Summer"]

    name: Control.property()

    tag: 'tr'


class ScheduleView extends Control
    inherited:
        content:
            control: List
            itemClass: YearView
            ref: 'yearViewList'
            mapFunction:
                name: 'name'
            items: ["1", "2", "3", "4"]

        css:
            'border-left': '2px solid black'
            'border-bottom': '2px solid black'
            'border-spacing': '0px'
            'font-family': 'Helvetica, Arial, sans'

    # This will correspond to a meteor cursor or something similar
    years: Control.property()

    tag: 'table'


class ScheduleUI extends Control
    inherited:
        content:
            control: HorizontalPanels
            left:
                control: ScheduleView
                ref: 'scheduleView'
            right:
                control: MajorView
                ref: 'majorView'

        css:
            'width': '900px'
            'height': '700px'

