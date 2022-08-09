#!/usr/bin/env bash

_dir="$(dirname $0)"

_bare_dir="$_dir/emacs"
_src_dir="$_dir/src/emacs"

# _tmp_bare_dir="$(mktemp -d)"
_tmp_src_dir="$(mktemp -d)"

source $_dir/PKGBUILD

echo "	Updating bare repo in $_bare_dir"

# Just delete the bare repo is simpler

rm -rf $_bare_dir
git clone --bare --depth=1 $_REPO $_bare_dir

cd $_bare_dir
_branch="$(git branch --show-current)"

# git fetch --prune origin $_branch:$_branch

echo "	Updating source code in $_src_dir"

mkdir -p $_src_dir

# Delete old tracked source files (some of them maybe moved/deleted upstream)
cd $_src_dir
rm -rf $(git ls-files) .git

git clone $_bare_dir $_tmp_src_dir
rsync -r --remove-source-files $_tmp_src_dir/. $_src_dir/

# # makepkg creates the source directory with "origin" pointed to the bare repo
# git remote add origin1 $_REPO 2>/dev/null
# git fetch --depth=1 origin1 $_branch
# git reset --hard origin1/$_branch

## doesn't work!
# git reset --hard origin/$_branch # --git-dir="$_bare_dir"
