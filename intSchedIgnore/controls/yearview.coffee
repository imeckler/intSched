class YearView extends Control
    inherited:
        itemClass: QuarterView
        mapFunction: 'season'
        items: ["Autumn", "Winter", "Spring", "Summer"]

    name: Control.property()

    tag: "tr"