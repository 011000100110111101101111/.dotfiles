#!/bin/bash
#
#


test=$(~/.dotfiles/Guides/checkCommits.sh)

if [ "$test" -gt 0 ]; then
  echo "Uncommitted"
fi
