#!/bin/sh -l

/yamlfixer --verbose /github/workspace/app/$YAML_FILE

result=$?
if [ $result -ne 0 ] ; then
  echo "WARN: all input files didn't pass successfully yamllint strict mode." ;
  echo "INFO : create a new branch with corrections." ;
  cd /github/workspace/app/
  branch_name=$(git branch --show-current)
  repository_name=$(basename $(git remote get-url origin) .git)
  echo $repository_name
  git config --global user.email "toto@opt.nc"
  git config --global user.name "Toto"
  git checkout -b yamlfixer_patch
  git add --all
  git commit -m 'yamlfixer patch proposition'
  echo "INFO : create a pull request." ;
  curl  -v -X POST -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/opt-nc/$repository_name/pulls \
  -d '{"head":"yamlfixer_patch","base":'$branch_name'}'
else
  echo "INFO : all input files either are skipped or successfully pass yamllint strict mode." ;
fi ;

exit $result
