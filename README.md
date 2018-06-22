# scripts & queries
Various scripts and queries for OSM and Qality assurance

## Italy Highway Names
### getting municipalities
we need an overpass-turbo query to get codici ISTAT of all italian municipalities:
http://overpass-turbo.eu/s/zJg
then filter province codes (first 3 digits):
cat | cut -c 1-3 | sort -u

### gathering street names in batches
ItalyHighwayNames.sh splits query task in several province based queries. Refer to codes filtered above
