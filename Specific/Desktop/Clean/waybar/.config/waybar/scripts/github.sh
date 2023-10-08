#!/bin/bash
#
#


test=$(~/.dotfiles/Guides/checkCommits.sh)

if [ "$test" -eq "1" ]; then
  echo "Uncommitted"
fi
