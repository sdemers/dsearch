. ./config.sh

redo-ifchange ${SRCS}

${DMD} ${SRCS} -w -I.. -lib -of$3
