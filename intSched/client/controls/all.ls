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

objToView = (obj) ->
  if typeof obj == 'string'
    CourseView.create!.json(
      title: obj
      numNeeded: 1)
  else
    BinView.create!.json(
      numNeeded: obj.num
      obj: obj
      title: obj.title
      binList:
        control: List
        items: map objToView, obj.list
      watchList: [(x.title || x).replace ' ', '_' for x in obj.list])

I.objToView = objToView

class MajorView extends BinView
  -> BinView.apply this, arguments

  setBinFromName = (name) -> 
    @_obj I.collections.majors.findOne 'name': name

  _obj: Control.property (obj) ->
    @content objToView obj.bin

  name: Control.property (name) ->
    @_obj setBinFromName name

  initialize: ->
    if not @_obj! and @name!
      @_obj setBinFromName name

I.controls.MajorView = MajorView
