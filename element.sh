#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

if [[ ! $1 ]]
then
  echo Please provide an element as an argument.
else

  # input is a number or not
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ELEMENTS_QUERY_RESULT=$($PSQL "select * from elements where atomic_number=$1")
  else
    ELEMENTS_QUERY_RESULT=$($PSQL "select * from elements where symbol='$1' or name='$1'")
  fi

  # if it finds something
  if [[ -n $ELEMENTS_QUERY_RESULT ]]
  then
    echo $ELEMENTS_QUERY_RESULT | while IFS="|" read ATOMIC_NUMBER SYMBOL NAME
    do
      PROPERTIES_QUERY_RESULT=$($PSQL "select atomic_mass, melting_point_celsius, boiling_point_celsius, type_id from properties where atomic_number=$ATOMIC_NUMBER")
      echo $PROPERTIES_QUERY_RESULT | while IFS="|" read ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE_ID
      do
        TYPE=$($PSQL "select type from types where type_id=$TYPE_ID")

        echo The element with atomic number $ATOMIC_NUMBER is $NAME \($SYMBOL\). It\'s a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius.
      done
    done
  else
    # not found nothing
    echo I could not find that element in the database.
  fi
fi
