#!/bin/bash

#  for i in data/* do mongoimport --db plannerDB --collection modules --file $i --jsonArray

# Function to echo this script's help
print_help ()
{
    echo "Usage ./runserver.sh <options>"
    echo
    echo "Startup script for setting up the development environment of the module planner"
    echo "it perfoms tasks such as initialising mongodb and django's development server"
    echo
    echo "-h,   --help          Print this help"
    echo "      --fresh-data    Discards the previous data stored in database and imports a fresh set"
    echo "                      from the /data directory in the project"
}

# Ok since we are now adding command line options to this script we need a way to parse them
# So let's loop until there are no more options to parse
while [[ $# > 0 ]]
do
    # Set our dummy variable to the next option
    arg=$1

    # Shift the variables along by one so $3 -> $2, $2 -> $1 etc
    shift

    # Use a case statement to decide what to do
    # ';;' is equivalent to the 'break' command found in other languages such as C or Python
    case $arg in

        # Using | for an OR case so we can match short and long form of commands
        -h | --help)
            print_help
            exit
            ;;

        --fresh-data)
        # This option means we want a fresh import of the data found in /data
            echo "Option used"
            import_data=1
            ;;

        *)
        # Matches everything else i.e unknown commands
            echo "Unknown option: $arg"
            echo
            print_help
            exit
            ;;
    esac
done

# Change to project root and activate the virtualenv
echo "      => Activating Virtualenv"
cd ../
source env/bin/activate

# Descend into the module_planner and start mongodb
echo "      => Starting MongoDB Server"
mongod --dbpath db/ --smallfiles &
sleep 10

# If we were asked to, import fresh data
if [[ $import_data -eq 1 ]]; then
    echo "\t=> Importing Data - Old data WILL be lost!!"

    # Switch to the data directory
    cd data

    # First import nothing with the --drop option to clear the database
    echo | mongoimport --drop --db plannerDB --collection modules

    # Now loop through all .json files and import them
    for i in *.json; do
        mongoimport --db plannerDB --collection modules --file $i --jsonArray
    done

    # Go back
    cd ..
fi

# Start python development server
echo "      => Starting Development Server"
cd module_planner/
python manage.py runserver
