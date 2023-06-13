#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --tuples-only -c"

INPUT=$1
#checks if argument is given or not
if [[ -z $INPUT ]]
then
  echo  "Please provide an element as an argument."
  exit
fi

#checks if argument is atomic number
if [[ $INPUT =~ ^[1-9]+$ ]]
then
  ELEMENT=$($PSQL "select atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements join properties using(atomic_number) join types using(type_id) where atomic_number = '$INPUT'")
else
#checks if argument is not atomic number
  ELEMENT=$($PSQL "select atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements join properties using(atomic_number) join types using(type_id) where name = '$INPUT' or symbol = '$INPUT'")
fi

#element doesn't exist
if [[ -z $ELEMENT ]]
then
  echo  "I could not find that element in the database."
  exit
fi

echo $ELEMENT | while IFS=" |" read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS 
do
  echo  "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
done
