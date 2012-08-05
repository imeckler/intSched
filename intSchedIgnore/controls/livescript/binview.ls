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