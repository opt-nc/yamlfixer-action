#!/bin/sh -l

/yamlfixer --verbose /github/workspace/app/$YAML_FILE

result=$?
if [ $result -ne 0 ] ; then
  echo "WARN: all input files didn't pass successfully yamllint strict mode." ;
else
  echo "INFO : all input files either are skipped or successfully pass yamllint strict mode." ;
fi ;

cd /github/workspace/app/
git status

exit $result
