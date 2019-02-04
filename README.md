# scripts & queries
Various scripts and queries for OSM and Quality assurance

## ItalyHighwayNames
### getting municipalities
Overpass-turbo query yields codici ISTAT (ref:ISTAT OSM tag) of all italian municipalities (municipality_codes), then filter province codes by first 3 digits (province_codes).

### gathering street names in batches
ItalyHighwayNames.sh splits query task in several province based queries for actual data, referring to codes filtered above. Running nationwide:
while read province_codes; do ./ItalyHighwayNames.sh $province_codes; done

### querying via telegram bot
odonym.py runs a telegram bot that filters names on a provided string and provide a georeferenced csv for download
just search for bot @italynames_bot and type a name or a part of it (case sensitive)
