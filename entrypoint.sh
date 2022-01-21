#!/bin/sh -l

if [ $VERBOSE ] ; then
  echo "INFO: verbose mode detected."
  options="--verbose "
fi;

if [ $DEBUG ] ; then
  echo "INFO: debug mode detected."
  options+="--debug"
fi;

yamlfixer $options /github/workspace/app/$YAML_FILE

result=$?
if [ $result -ne 0 ] ; then
  echo "WARN: all input files didn't pass successfully yamllint strict mode." ;
  echo "INFO : create a new branch with corrections." ;
  cd /github/workspace/app/
  branch_name=$(git branch --show-current)
  repository_name=$(basename $(git remote get-url origin) .git)
  current_timestamp=$(($(date +%s)))
  git config --global user.email $USER"@opt.nc"
  git config --global user.name $USER
  git checkout -b yamlfixer/patch/$branch_name/$current_timestamp
  git add --all
  git commit -m 'Yamlfixer : fix yaml files '$YAML_FILE
  git push origin yamlfixer/patch/$branch_name/$current_timestamp
  echo "INFO : create a pull request." ;
  curl  -u $USER:$TOKEN -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/opt-nc/$repository_name/pulls -d '{"head":"'yamlfixer/patch/$branch_name/$current_timestamp'","base":"'$branch_name'", "title":"Fix yaml files '$YAML_FILE'"}'
else
  echo "INFO : all input files either are skipped or successfully pass yamllint strict mode." ;
fi ;

exit $result
