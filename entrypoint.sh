#!/bin/sh -l

cd /github/workspace/
yamlfixer $OPTIONS --nochange --recurse -1 --diffto /tmp/changes.patch . $YAML_FILE

if [[ -s /tmp/changes.patch ]] ; then
  echo "WARN: all input files didn't pass successfully yamllint strict mode." ;

  git config --global --add safe.directory /github/workspace
  base_branch_name=$(git branch --show-current)
  patch_branch_name=yamlfixer/patch/$base_branch_name
  repo_url=$(git remote get-url origin)
  repository_name=${repo_url##*.com/}

  git config --global user.email noreply@github.com
  git config --global user.name $USER
  git fetch

  # If current branch is the patch branch, just push
  if [[ "$base_branch_name" == *"yamlfixer/patch"* ]]; then
    echo "INFO : PR already exists, and currently working on the branch. Rebase with remote branch and push"
    git pull --rebase
    patch -p0 < /tmp/changes.patch
    git commit -a -m 'Yamlfixer : fix yaml files'
    git push origin $base_branch_name
  else
    # Check if a remote patch branch exists for the current branch
    remote_branch_exists=$(git ls-remote --heads origin $patch_branch_name)
    if [[ -n "$remote_branch_exists" ]]; then
      echo "INFO : branch already exists, just merge and push"
      git checkout $patch_branch_name
      git pull --rebase
    else
      echo "INFO : branch not found, create a new branch and push fixes." ;
      git checkout -b $patch_branch_name
    fi

    patch -p0 < /tmp/changes.patch
    git commit -a -m 'Yamlfixer : fix yaml files'
    git push origin $patch_branch_name


    if [[ -z "$remote_branch_exists" ]]; then
      echo "INFO : create a pull request." ;
      curl  -H "Accept: application/vnd.github.v3+json" -H "Authorization: token "$TOKEN https://api.github.com/repos/$repository_name/pulls -d '{"head":"'$patch_branch_name'","base":"'$base_branch_name'", "title":"Fix yaml files"}'
    fi
  fi
  exit 1
else
  echo "INFO : all input files either are skipped or successfully pass yamllint strict mode." ;
  exit 0
fi ;
