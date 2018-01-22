#!/bin/bash

for lang_dir in */
do
  cd $lang_dir
  for dir in */
  do
    cd $dir
    output="../${dir%/}_files.csv"
    rm $output
    while read line
    do
      if [ "$line" != "" ]; then
        echo "---- $line ----" >> $output
        git show --stat --no-commit-id -r $line > temp
        cat temp >> $output
        rm temp
      fi
    done < ../${dir%/}_shas.csv

    echo "done with $dir"
    cd ..
  done
  cd ..
done

echo "done!"
