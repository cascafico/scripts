#!/bin/bash
# multiple overpass-turbo queries that aim to list highway NAME dissemination in Italy
# ref:ISTAT OSM tag is used, since it is a unique identifier for each italian municipality
# ref:ISTAT code is a 6 digit; first can be 0|1; here a small range has been set 042-043

# batch runs for nationwide extractions can be compiled as:
# for i in ???; do echo "./ItalyHighwayNames.sh $i" >> batchrun; done
# where ??? files are the generated province code files (arg 0 option)
# containing municipality codes


PROVINCECODE="$1"


if [ $# -eq 0 ]
   then
     echo ""
     echo "Usage:"
     echo "./ItalyHighwayNames.sh : this summary"
     echo "./ItalyHighwayNames.sh 0 : province and municipality codes generation"
     echo "./ItalyHighwayNames.sh <3 digits province code> : province highway names generation"
     echo "./ItalyHighwayNames.sh <3 digits province code> <max 2 strings name>: province highway name generation"
     echo ""
     echo ""
     exit
fi

# first run municipality and province codes generation
if [ $1 == 0 ]
   then
     echo ""
     echo "Generating municipality and province codes"
     echo ""
     echo ""
     sleep 3
     wget -nc -O municipality_codes 'http://overpass-api.de/api/interpreter?data=[out:csv("ref:ISTAT";false)];area[name="Italia"];relation(area)["ref:ISTAT"][admin_level=8];out;' 
     cat municipality_codes | cut -c 1-3 | sort -u > province_codes
     # below range obtained by sort head and tail province_codes
     for i in $(eval echo {001..111}); do 
       cat municipality_codes | grep "^$i" > $i
     done
     exit
fi

# overpass-turbo actual highway=name queries

# province code only (all names)
if [ $# -eq 1 ]
   then
   echo "generating province code $1 all highway names"
   echo ""
   sleep 3
   if [ -f $1_names.csv ]; then
      echo "province $1 already processed"
      exit
   fi
   while read PROVINCECODE
   do
    wget -nc -O $PROVINCECODE.csv 'http://overpass-api.de/api/interpreter?data=[out:csv("name",::lat,::lon;false;",")][timeout:600];area["ref:ISTAT"~"'$PROVINCECODE'"][admin_level=8];way(area)[highway]["name"~" "];out center;'
   sort -u -t, -k1,1 $PROVINCECODE.csv >> $1_names.csv
   rm $PROVINCECODE.csv
   done < $PROVINCECODE
fi

# province and on or two strings name
if [ $# -ge 2 ]
   then
   echo ""
   echo "generating province code $1 highway names containing \"$2 $3\""
   echo ""
   echo ""
   sleep 3
   while read PROVINCECODE
   do
    wget -nc -O $PROVINCECODE.csv 'http://overpass-api.de/api/interpreter?data=[out:csv("name",::lat,::lon;false;",")][timeout:600];area["ref:ISTAT"~"'$PROVINCECODE'"][admin_level=8];way(area)[highway]["name"~"'$2' '$3'"];out center;'
   sort -u -t, -k1,1 $PROVINCECODE.csv >> $PROVINCECODE-$2_$3.csv
   rm $PROVINCECODE.csv
   done < $PROVINCECODE
fi
