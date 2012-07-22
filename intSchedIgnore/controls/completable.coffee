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
