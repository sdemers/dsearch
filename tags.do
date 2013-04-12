. ./config.sh

redo-ifchange json ${GEOMD}/json
redo-always

${D2TAGS} *.json ${GEOMD}/*.json >$3
