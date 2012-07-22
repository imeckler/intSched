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
