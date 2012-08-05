import json

course_list = []

with open('courses.py', 'r') as course_file:
    course_dict = eval(course_file.read())
    for department, courses in course_dict.iteritems():
        for course in courses:
            course['department'] = department
            terms = course['terms_offered']
            if terms:
                course['terms_offered'] = terms.split(', ')
            course_list.append(course)

course_json = json.dumps(course_list)
with open('fullcourselist.js', 'w') as course_js:
    course_js.write('fullcourselist = ' + course_json)