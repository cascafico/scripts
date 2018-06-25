#!/bin/bash
# multiple overpass-turbo queries that aim to list highway NAME dissemination in Italy
# ref:ISTAT OSM tag is used, since it is a unique identifier for each italian municipality
# ref:ISTAT code is a 6 digit; first can be 0|1; here a small range has been set 042-043

if [ $# -eq 0 ]
   then
     echo ""
     echo "Usage: script accepts two provincia codes and optionally one odonym (max 3 words), ie: 023 027 Emanuele Terzo"
     echo "       optionally first argument 0 for province and municipality codes generation"
     echo ""
     echo "Scripts runs several overpass-turbo queries in a selected provincie range"
     echo "Each provincia query creates a .lst file"
     echo "If for some reason you get zero size lst (likely for overpass-turbo timeouts), remove lst files (find *.lst -size  0 -print0 |xargs -0 rm --) and rerun script"
     echo "Script does not overwrite .lst files"
     echo ""
     exit
fi

# first run municipality and province codes generation
if [ $1 == 0 ]
   then
     wget -nc -O municipality_codes 'http://overpass-api.de/api/interpreter?data=[out:csv("ref:ISTAT";false)];area[name="Italia"];relation(area)["ref:ISTAT"][admin_level=8];out;' 
     cat municipality_codes | cut -c 1-3 | sort -u > province_codes
     exit
fi


# overpass-turbo actual highway=name queries
if [ $# -eq 2 ] 
   then
   for i in $(eval echo {$1..$2}); do 
   wget -nc -O $i.lst 'http://overpass-api.de/api/interpreter?data=[out:csv("name",::lat,::lon;false;",")][timeout:600];area["ref:ISTAT"~"'$i'..."][admin_level=8];way(area)[highway][name];out center;' 
sort -u -t, -k1,1 $i.lst -o $i.lst
done
fi

if [ $# -eq 3 ] 
   then
   for i in $(eval echo {$1..$2}); do 
   wget -nc -O $i.lst 'http://overpass-api.de/api/interpreter?data=[out:csv("name",::lat,::lon;false;",")][timeout:600];area["ref:ISTAT"~"'$i'..."][admin_level=8];way(area)[highway]["name"~"'$3'"];out center;' 
sort -u -t, -k1,1 $i.lst -o $i.lst
done
fi

echo "Empty files: "
find . -size 0
echo ""
read -t 999 -n 1 -p "Do you wish to remove zero size results (y/N)? " answer
if [ "$answer" == "y" ] 
   then
   find *.lst -size  0 -print0 |xargs -0 rm --
fi


# optionallyi, odonym filter on all italian municipalities
#if [ $# -gt 2 ]
#  then
#    echo "\"$3 $4 $5\" occourences are being written in $3.csv file"
#    cat ???.lst | grep "$3 $4 $5" > $3.csv
#    sed -i '1 i\odonimo,lat,lon' $3.csv
#fi
