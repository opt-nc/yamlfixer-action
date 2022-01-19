#!/bin/sh -l

/yamlfixer --verbose /github/workspace/app/$YAML_FILE

result=$?
if [ $result -ne 0 ] ; then
  echo "WARN: all input files didn't pass successfully yamllint strict mode." ;
  branch_name=$(git branch --show-current)
  repository_name=$(basename `git rev-parse --show-toplevel`)
  cd /github/workspace/app/
  echo "INFO : create a new branch with corrections." ;
  git checkout -b yamlfixer_patch
  git add --all
  git commit -m 'yamlfixer patch proposition'
  echo "INFO : create a pull request." ;
  curl  -X POST -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/opt-nc/$repository_name/pulls \
  -d '{"head":"yamlfixer_patch","base":'$branch_name'}'
else
  echo "INFO : all input files either are skipped or successfully pass yamllint strict mode." ;
fi ;

exit $result
