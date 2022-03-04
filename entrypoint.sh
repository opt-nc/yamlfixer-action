#!/bin/sh -l

yamlfixer $OPTIONS /github/workspace/$YAML_FILE

result=$?
if [ $result -ne 0 ] ; then
  echo "WARN: all input files didn't pass successfully yamllint strict mode." ;
  echo "INFO : create a new branch with corrections." ;
  cd /github/workspace
  branch_name=$(git branch --show-current)
  repo_url=$(git remote get-url origin)
  repository_name=${repo_url##*.com/}
  current_timestamp=$(($(date +%s)))

  git config --global user.email noreply@github.com
  git config --global user.name $USER
  git checkout -b yamlfixer/patch/$branch_name/$current_timestamp
  git add $YAML_FILE
  git commit -m 'Yamlfixer : fix yaml files '$YAML_FILE
  git push origin yamlfixer/patch/$branch_name/$current_timestamp


  echo "INFO : create a pull request." ;
  curl  -H "Accept: application/vnd.github.v3+json" -H "Authorization: token "$TOKEN https://api.github.com/repos/$repository_name/pulls -d '{"head":"'yamlfixer/patch/$branch_name/$current_timestamp'","base":"'$branch_name'", "title":"Fix yaml files '$YAML_FILE'"}'
else
  echo "INFO : all input files either are skipped or successfully pass yamllint strict mode." ;
fi ;

exit $?


