#!/bin/bash

#  for i in data/* do mongoimport --db plannerDB --collection modules --file $i --jsonArray

# Change to project root and activate the virtualenv
echo "      => Activating Virtualenv"
cd ../
source env/bin/activate

# Descend into the module_planner and start mongodb
echo "      => Starting MongoDB Server"
mongod --dbpath db/ --smallfiles &
sleep 5

# Start python development server
echo "      => Starting Development Server"
cd module_planner/
python manage.py runserver
