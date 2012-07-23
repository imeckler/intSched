class ScheduleUI extends Control
    inherited:
        content:
            control: HorizontalPanels
            left:
                control: ScheduleView
                ref: 'scheduleView'
            right:
                control: MajorView
                ref: 'majorView'

        css:
            'width': '900px'
            'height': '700px'


class ScheduleUI extends Control
    inherited:
        content:[
            {
                control: ScheduleView
                css:
                    'float': 'left'
                ref: 'scheduleView'
            }
            {
                control: MajorView
                css:
                    'float': 'right'
                ref: 'majorView'
            }
        ]

        css:
            'width': '900px'
            'height': '700px'
