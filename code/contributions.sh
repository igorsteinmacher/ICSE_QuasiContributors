#!/bin/bash
for lang in */
do
  cd $lang
  echo "startin on $lang"
  for dir in */
  do
    echo "   startin on $dir"
    > ${dir%/}_ccs.csv
   cd $dir; cp ../../contributions.sh .

    git shortlog -sn | grep "     1" | tr " 1 " " " | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' > committers.txt
    cat committers.txt | while read line
    do
      echo "###---" >> ../${dir%/}_test.txt
      git log -E --author="^${line}\s<(.+)>$" --pretty=format:"%h,%an,%ae,%ai" --name-only >> ../${dir%/}_test.txt
    done
    echo "   done with $dir"
    rm committers.txt contributions.sh
    cd ..
  done
  cd ..
  echo "done with $lang"
done
echo "done!"
