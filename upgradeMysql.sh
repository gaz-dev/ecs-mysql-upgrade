#!/bin/bash
# usage
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3"  ] || [ -z "$4"  ] || [ -z "$5"  ]
then
  echo -e -e "usage: $0 <script_directory> <db_username> <db_host> <db_name> <db_password>"
  exit 1
fi
# set varaibles from command line
export MYSQL_PWD=$5
export DB_HOST=$3
export DB_USERNAME=$2
export DB_NAME=$4
export SCRIPTS_DIR=$1
export DB_CONN="mysql -u${DB_USERNAME} -h${DB_HOST} -D${DB_NAME}"
# get current database version from versionTable
currentVersion ()
{
  ${DB_CONN} -N -e "select "*" from versionTable"
}
echo -e "\n================================================="
echo -e "current database version =" $(currentVersion)
echo -e "================================================="
# get the greatest script number available
latestScriptVersion=$(ls ${SCRIPTS_DIR} | awk -F "[^0-9]*" '{print $1}' | sort -n | tail -1)
echo -e "\n================================================="
echo -e "latest script version = " ${latestScriptVersion}
echo -e "================================================="
# if the latest script number is beyond the current database version run
# any scripts post current version up to latest
if [ $latestScriptVersion -gt $(currentVersion) ]
then
  echo -e "\n================================================="
  echo -e "running database upgrade"
  for file in $(ls ${SCRIPTS_DIR} | grep ^[0-9]. | sort -n)
  do
    if [ $(echo -e $file | awk -F "[^0-9]*" '{print $1}') -gt $(currentVersion) ]
    then
      echo -e "running upgrade script $file"
      fileVersion=$(echo -e $file | awk -F "[^0-9]*" '{print $1}')
      ${DB_CONN} < ${SCRIPTS_DIR}/$file
      # if update to this version succeeded update version table
      if [ $? -eq 0 ]
      then
        ${DB_CONN} -e "update versionTable set version = ${fileVersion}"
        echo -e "database ${DB_NAME} upgraded to version ${fileVersion}"
        echo -e "output from version table"
        currentVersion
        echo -e "================================================="
      else
        # log error and exit upgrade process
        echo -e "running of upgrade $file ended in error ... exiting"
        echo -e "database is currently at version"
        currentVersion
        echo -e "================================================="
        exit 1
      fi
    fi
  done
# database is already at latest version
elif [ ${latestScriptVersion} -eq $(currentVersion) ]
then
  echo -e "\n================================================="
  echo -e "database is at the latest version"
  echo -e "output from version table"
  currentVersion
  echo -e "================================================="
fi

