#!/bin/bash


for dir in */
do
  cd $dir
  while IFS= read -r var
  do
    IFS=';' read -a var <<< "$var"
  #  echo ${var[2]}
    com=$(git cat-file -t ${var[2]})
    echo "$com - $var" >> ../${dir%/}_saida.csv
    if [ "$com" = "commit" ]
    then
       echo $var >> ../${dir%/}_temCommit.csv
    fi
    if [ "$com" == "tree" ]
    then
       echo $var >> ../${dir%/}_temCommit.csv
    fi
  done < ../${dir%/}_shas.csv
  cd ..
done



