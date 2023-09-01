#!/bin/sh

# Perform add commit push with git command
# Usage: pushgit.sh "commit message"

# 引数の指定がなかったらエラー終了
if [ $# -eq 0 ]; then
  echo "Usage: pushgit.sh \"commit message\""
  exit 1
fi

git add .
git commit -m "$1"
git push

