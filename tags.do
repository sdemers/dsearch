. ./config.sh

redo-ifchange json ${GEOMD}/json
redo-always

if [ -x ${D2TAGS} ]; then
    ${D2TAGS} *.json ${GEOMD}/*.json >$3
fi
