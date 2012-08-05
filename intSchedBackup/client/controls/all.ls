I.controls = {}

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

class BinView extends Completable
  -> return Completable.apply this, arguments

  inherited:
    content:
      control: CollapsibleWithHeadingButton
      ref: 'collapsible'

  complete: (complete) ->
    if complete is undefined then @_super!
    else
      @_super complete
      if complete
        @css 'background-color': 'green'
      else
        @css 'background-color': 'white'

  number: Control.property!

  binList: Control.property (binList) ->
    @$collapsible!.content binList

  obj: Control.property!

  title: Control.chain '$collapsible', 'heading'

I.controls.BinView = BinView

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
