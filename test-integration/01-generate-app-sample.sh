#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'

#-------------------------------------------------------------------------------
# Change in template directory
#-------------------------------------------------------------------------------
cd test-integration/samples/$1
echo "*** changed directory in : test-integration/samples/"$1


#-------------------------------------------------------------------------------
# Run NHipster Generator
#-------------------------------------------------------------------------------
echo "*** run generation app with nodejs blueprint for : "$1

runOptions="--blueprints nodejs --skip-git --skip-checks --force --no-insight --skip-install"

if [ "$2" = "import-jdl" ]; then
  runOptions="import-jdl "$1".jdl $runOptions"
fi

jhipster $runOptions

if [ "$2" = "post-import-jdl" ]; then
  echo "*** run import jdl after generation for : "$1
  jhipster import-jdl $1.jdl $runOptions
fi

echo "*** check if the generation is wrong for some default java classes created :"

if [ -z $(find src -type f -name "*.java" ) ]; then
      echo "${GREEN}GENERATION OK"
else
      echo "${RED}WRONG GENERATION"
      exit 1
fi

echo "*** install client dependencies for : "$1
sudo npm install
if [ $? -ne 0 ]; then
  echo "${RED}FAILED CLIENT INSTALL"
  exit 1
fi
echo "*** install server dependencies for : "$1
cd server && sudo npm install
if [ $? -ne 0 ]; then
  echo "${RED}FAILED SERVER INSTALL"
  exit 1
fi
