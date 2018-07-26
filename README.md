# scripts & queries
Various scripts and queries for OSM and Qality assurance

## ItalyHighwayNames
### getting municipalities
Overpass-turbo query yields codici ISTAT (ref:ISTAT OSM tag) of all italian municipalities (municipality_codes), then filter province codes by first 3 digits (province_codes).

### gathering street names in batches
ItalyHighwayNames.sh splits query task in several province based queries for actual data, referring to codes filtered above. Running nationwide:
while read province_codes; do ./ItalyHighwayNames.sh $province_codes; done
