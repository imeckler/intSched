class Schedule extends Control
    inherited:
        content:
            control: List
            itemClass: Year

    # This will correspond to a meteor cursor or something
    years: Control.property()