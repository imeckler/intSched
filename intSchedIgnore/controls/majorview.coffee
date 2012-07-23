# We may need an additional parameter or something to build up a long name
# so we don't have any collisions eventwise
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