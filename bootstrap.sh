#!/bin/bash

git pull origin master

function doit() {
    rsync --exclude ".git/" \
          --exclude "bootstrap.sh" \
          --exclude "apt.sh" \
          --exclude "README.sh" \
          --exclude "LICENSE" \
          -avh --no-perms . ~
}

doit
