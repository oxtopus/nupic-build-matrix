Docker Build Matrices
=====================

Herein contains a collection of platform-specific Dockerfiles useful for
building nupic and nupic.core from source in a variety of specific linux
environments.

There is an included CoreOS and Vagrant configuration for running these builds
in a virtualbox environment on Mac OS X, but if already running in Linux, only
Docker is required.

### Before you begin

This project is standalone and requires a local clone of nupic.  The intended
use-case for a project like this is in a continuous integration environment
that regularly fetches a remote nupic repository, resets to a specific version
and then builds that version in one or more platform-specific docker
containers.  As such, clone nupic at the root of this project, and optionally
reset to a specific commit sha -- otherwise master is used.  Because of a
specific requirement by Docker related to paths, you will need to do a separate
shallow clone (instructions follow) from this location into the
platform-specific target directory.

Usage
-----

If using OS X + Virtualbox + CoreOS + Vagrant, first provision the vm and log
into it:

    vagrant up
    vagrant ssh

Once logged in, the $TARGET below can be any one of the directories in this
repository that contains a Dockerfile:

    cd nupic-build-matrix
    git clone --depth=1 file:////home/core/nupic-build-matrix/nupic/ $TARGET/nupic
    cd $TARGET
    docker build -t nupic:`git rev-parse HEAD` .

Supported platforms
-------------------

- [x] Ubuntu 14.04 + gcc
- [x] Ubuntu 14.04 + clang
- [x] CentOS 6 + gcc
- [x] CentOS 7 + gcc
- ???
