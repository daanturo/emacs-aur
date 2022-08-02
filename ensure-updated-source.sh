#!/usr/bin/env bash

_dir="$(dirname $0)"

_bare_dir="$_dir/emacs"
_source_dir="$_dir/src/emacs"

source $_dir/PKGBUILD

echo "	Updating bare repo in $_bare_dir"
# rm -rf $_bare_dir
[[ -d $_bare_dir ]] || git clone --bare --depth=1 $_REPO $_bare_dir

cd $_bare_dir
_branch="$(git branch --show-current)"

git fetch --depth=1 --prune origin $_branch:$_branch

echo "	Updating source code in $_source_dir"

[[ -d $_source_dir ]] || git clone $_bare_dir $_source_dir

cd $_source_dir

# # makepkg creates the source directory with "origin" pointed to the bare repo
# git remote add origin1 $_REPO 2>/dev/null
# git fetch --depth=1 origin1 $_branch
# git reset --hard origin1/$_branch
git reset --hard origin/$_branch # --git-dir="$_bare_dir"
