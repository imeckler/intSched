class Completable extends Control
  -> return Control.apply this, arguments

  numNeeded: Control.property!

  watchList: Control.property (watchList) ->
    @off!
    for e in @watchList!
      @on e, (ev) ~> @_numComplete @_numComplete! + 1

  complete: Control.property.bool(
    !(complete) -> if complete then @trigger @title!.replace ' ', '_'
    false)

  _numComplete: Control.property(
    !(numComplete) -> if numComplete == @numNeeded! then @complete true
    0)

  initialize: ->
    if not @watchList! then return
    for e in @watchList!
      @on e, (ev) ~> @_numComplete @_numComplete! + 1

I.controls.Completable = Completable
