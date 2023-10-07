#!/bin/bash

if [[ `git status --porcelain` ]]; then
  echo "1"
fi
