#!/bin/bash

if [[ "x${1}" == 'x' ]]
then
  echo "usage: ${0} <installer-filename>"
  exit 1
fi

if [[ `echo ${1} | rev | cut -d '.' -f1 | rev` != 'run' ]]
then
  echo "EDB installer must be a .run binary"
  exit 1
fi

INSTALLER_FILENAME=${1}
VERSION=`echo ${INSTALLER_FILENAME} | cut -f2 -d'-'`
PGMAJOR=`echo ${VERSION} | cut -f1-2 -d'.'`
V=`echo ${PGMAJOR} | sed "s/\.//"`

cat Dockerfile.installer_template | sed "s/%%PGMAJOR%%/${PGMAJOR}/" > Dockerfile

docker build --build-arg INSTALLER_FILENAME=${INSTALLER_FILENAME} -t ppas${V}:${VERSION} . 2>&1 | tee ppas${V}_${VERSION}_build.log
