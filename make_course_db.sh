#!/bin/bash

cd intSched
meteor &
pid=$!
cd ..

sleep 3
mongo 127.0.0.1:3002/meteor intSchedIgnore/courses.js

kill $pid