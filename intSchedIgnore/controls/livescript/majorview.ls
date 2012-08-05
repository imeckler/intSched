objToView = (obj) ->
  if typeof obj == 'string'
    CourseView.create!.json
      title: obj
      numNeeded: 1
  else
    BinView.create!.json
      numNeeded: obj.num
      obj: obj
      title: obj.title
      binList:
        control: List
        items: map objToView, obj.List
      watchList: [(x.title || x).replace ' ', '_' for x in obj.list]

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
