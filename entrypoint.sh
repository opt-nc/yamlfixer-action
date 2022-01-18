#!/bin/sh -l

./yamlfixer --verbose ./app/$YAML_FILE

result=$?
if [ $result -ne 0 ] ; then
  echo "WARN: all input files didn't pass successfully yamllint strict mode." ;
else
  echo "INFO : all input files either are skipped or successfully pass yamllint strict mode." ;
fi ;

git status

exit $result
