#!/bin/bash

ROOT=`pwd`

for dir in */
do
    cd "$dir"
    echo "em $dir"
    for subdir in */
    do
        cd "$subdir"
        echo "  --> $subdir"
        git shortlog -s > temp #--since=1.year
        output=$ROOT/${dir%/}/${subdir%/}.csv
        cat temp | awk '{print $1}' ORS=',' > $output
        rm temp
        echo "  done with $subdir"
        cd ..
    done
    echo "done with $dir"
    cd ..
done

rm alltogether.csv
cat *.csv > alltogether.csv

echo "Done!"

