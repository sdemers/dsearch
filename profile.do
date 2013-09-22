TESTRUNNER=testrunner

. ./config.sh

exec >&2

redo-ifchange ${LIBDEP}
redo-always

${DMD} -release -O -profile ${LIBDEP} *.d -cov -unittest ${INCL} -of${TESTRUNNER}

./${TESTRUNNER}

cat *.lst | grep "% covered"
