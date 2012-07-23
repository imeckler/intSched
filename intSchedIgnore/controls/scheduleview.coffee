class ScheduleView extends Control
    inherited:
        content:
            control: List
            itemClass: YearView
            ref: 'yearViewList'
            mapFunction:
                name: 'name'
            items: ["1", "2", "3", "4"]

        css:
            'border-left': '2px solid black'
            'border-bottom': '2px solid black'
            'border-spacing': '0px'
            'font-family': 'Helvetica, Arial, sans'

    # This will correspond to a meteor cursor or something similar
    years: Control.property()

    tag: 'table'