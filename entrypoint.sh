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
#  git config --global user.email "opt@opt.nc"
  git config --global user.name $USER
  git checkout -b yamlfixer/$branch_name
  git add --all
  git commit -m 'Yamlfixer : fix yaml files '$YAML_FILE
  git push origin yamlfixer/$branch_name
  echo "INFO : create a pull request." ;
  curl  -v -u $USER:$TOKEN -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/opt-nc/$repository_name/pulls -d '{"head":"'yamlfixer/$branch_name'","base":"'$branch_name'", "title":"Fix yaml files '$YAML_FILE'"}'
else
  echo "INFO : all input files either are skipped or successfully pass yamllint strict mode." ;
fi ;

exit $result
