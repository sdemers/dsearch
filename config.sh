DMD=dmd

GEOMD=../geomd
D2TAGS=../d2tags/d2tags

# All .d files are sources except the testrunner
SRCS=$(ls *.d | sed -e 's|testrunner.d||g')

LIBDEP=${GEOMD}/geomd.a

INCL=-I..
