#!/bin/bash

set -o errexit

function build {
  git clone --depth=1 $1 $2/nupic
  pushd $2
  docker build -t nupic:`(cd nupic && git rev-parse HEAD)`-$3 .
  rm -rf nupic
  popd
}

build $1 ubuntu/14.04/clang ubuntu-14.04-clang
build $1 ubuntu/14.04/gcc ubuntu-14.04-gcc
build $1 debian/jessie/clang debian-jessie-clang
build $1 centos/7/gcc centos-7-gcc
build $1 centos/6/gcc centos-6-gcc
