
db.courses.remove({});

for (var i = 0; i < courses.length; ++i) {
    db.courses.insert(courses[i]);
}