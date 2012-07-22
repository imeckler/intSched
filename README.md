If you want the course collection to have anything in it (though I haven't done anything using it yet), run "make_course_db". You only have to run it once.

Here's the contents of "type_into_console":

x = I.collections.majors.findOne()
a = I.objToView(x.bin)
intro = $(a.binList().items()[0]).control()
intro1 = $(intro.binList().items()[0]).control()
intro2 = $(intro.binList().items()[1]).control()
systems = $(intro.binList().items()[2]).control()
theory = $(intro.binList().items()[3]).control()
$('body').append(a)

After doing this, try doing setting complete to true on "intro1", "intro2", "systems", and "theory" (e.g., "intro1.complete(true)") to see how completion propagates to the parent view.