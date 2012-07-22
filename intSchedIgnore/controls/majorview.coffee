# We may need an additional parameter or something to build up a long name
# so we don't have any collisions eventwise
objToView = (obj) ->
    if typeof obj == 'string'
        CourseView.create().json
            title: obj
            numNeeded: 1
    else
        BinView.create
            watchList: ((o.title || o).replace ' ', '_' for o in obj.list)
            numNeeded: obj.num
            obj: obj
            title: obj.title
            binList:
                control: List
                items: objToView o for o in obj.list

class MajorView extends Completable
    _obj: Control.property

    name: Control.property

    initialize: ->
        @_obj I.collections.majors.find('name': name).fetch()
