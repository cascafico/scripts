#!/bin/bash
# multiple overpass-turbo queries that aim to list highway=name dissemination in Italy
# ref:ISTAT OSM tag is used, since it is a unique identifier for each italian municipality
# ref:ISTAT code is a 6 digit; first can be 0|1
# with first two arguments you can select a subset range to generate .lst files (one file, one province)

for i in $(eval echo {$1..$2}); do 
wget -nc -O $i.lst 'http://overpass-api.de/api/interpreter?data=[out:csv("name",::lat,::lon;false;",")];area["ref:ISTAT"~"'$i'..."];way(area)[highway][name];out center;' 
sort -u -t, -k1,1 $i.lst -o $i.lst
done
