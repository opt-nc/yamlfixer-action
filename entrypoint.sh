#!/bin/sh -l

cd /github/workspace/
yamlfixer $OPTIONS --nochange  --diffto /tmp/changes.patch $(find . -type f -name "*.yml" -o -name "*.yaml" -o -name ".yamllint" | grep -v ^./.github/workflows/) $YAML_FILE
echo "yamlfixer $OPTIONS --nochange  --diffto /tmp/changes.patch $(find . -type f -name "*.yml" -o -name "*.yaml" -o -name ".yamllint" | grep -v ^./.github/workflows/) $YAML_FILE"

if [[ -s /tmp/changes.patch ]] ; then
  echo "⚠️ WARN: all input files didn't pass successfully yamllint strict mode." ;

  git config --global --add safe.directory /github/workspace
  base_branch_name=$(git branch --show-current)
  patch_branch_name=yamlfixer/patch/$base_branch_name
  repo_url=$(git remote get-url origin)
  repository_name=${repo_url##*.com/}

  git config --global user.email noreply@github.com
  git config --global user.name $USER
  git fetch

  echo "ℹ️ INFO : linting $base_branch_name."

  # If current branch is the patch branch, just push
  if [[ "$base_branch_name" == *"yamlfixer/patch"* ]]; then
    echo "ℹ️ INFO : currently working on the patch branch $base_branch_name. Rebase with remote branch and push"
    git pull --rebase
    iteration=1
    while [[ -s /tmp/changes.patch ]]
    do
         patch -p0 < /tmp/changes.patch
         rm /tmp/changes.patch
         yamlfixer $OPTIONS --nochange  --diffto /tmp/changes.patch $(find . -type f -name "*.yml" -o -name "*.yaml" -o -name ".yamllint" | grep -v ^./.github/workflows/) $YAML_FILE
         let "iteration+=1"
         if [[ "$iteration" -gt 5 ]]; then
            break
         fi
    done

    if [[ "$iteration" -gt 5 ]]; then
       echo "❌ ERROR : some files were modified but too much problems remain, please check your yaml files or add yamllint exception."
    fi
    git commit -a -m 'Yamlfixer : fix yaml files'
    git push origin $base_branch_name
  else
    # Check if a remote patch branch exists for the current branch
    remote_branch_exists=$(git ls-remote --heads origin $patch_branch_name)
    if [[ -n "$remote_branch_exists" ]]; then
      echo "ℹ️ INFO : patch branch $patch_branch_name already exists, just merge and push"
      git checkout $patch_branch_name
      git pull --rebase
    else
      echo "ℹ️ INFO : patch branch not found, create a new patch branch $patch_branch_name and push fixes." ;
      git checkout -b $patch_branch_name
    fi

    iteration=1
    while [[ -s /tmp/changes.patch ]]
    do
       patch -p0 < /tmp/changes.patch
       rm /tmp/changes.patch
       yamlfixer $OPTIONS --nochange  --diffto /tmp/changes.patch $(find . -type f -name "*.yml" -o -name "*.yaml" -o -name ".yamllint" | grep -v ^./.github/workflows/) $YAML_FILE
       let "iteration+=1"
       if [[ "$iteration" -gt 5 ]]; then
         break
       fi
    done

    if [[ "$iteration" -gt 5 ]] ; then
       echo "❌ ERROR : some files were modified but too much problems remain, please check your yaml files or add yamllint exception."
    fi
    git commit -a -m 'Yamlfixer : fix yaml files'
    git push origin $patch_branch_name


    if [[ -z "$remote_branch_exists" ]]; then
      echo "ℹ️ INFO : create a pull request." ;
      curl  -H "Accept: application/vnd.github.v3+json" -H "Authorization: token "$TOKEN https://api.github.com/repos/$repository_name/pulls -d '{"head":"'$patch_branch_name'","base":"'$base_branch_name'", "title":"Fix yaml files"}'
    fi
  fi
  exit 1
else
  echo "ℹ️ INFO : 👍 all input files either are skipped or successfully pass yamllint strict mode." ;
  exit 0
fi ;
