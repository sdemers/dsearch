TESTRUNNER=testrunner

. ./config.sh

exec >&2

redo-ifchange ${LIBDEP}
redo-always

${DMD} -release -O ${LIBDEP} *.d ${INCL} -of${TESTRUNNER}

./${TESTRUNNER}
