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

    title: Control.chain('content')


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