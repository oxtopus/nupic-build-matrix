FROM ubuntu:14.04

MAINTAINER Austin Marshall <amarshall@numenta.com>

# Install dependencies
RUN apt-get update
RUN apt-get install -y \
    wget \
    git-core \
    gcc \
    g++ \
    cmake \
    python \
    python2.7 \
    python2.7-dev \
    zlib1g-dev \
    bzip2 \
    libyaml-dev \
    libyaml-0-2
RUN wget https://raw.github.com/pypa/pip/master/contrib/get-pip.py -O - | python
RUN pip install wheel
RUN pip install --upgrade setuptools

# Use gcc
ENV CC gcc
ENV CXX g++

# Set enviroment variables needed by NuPIC
ENV NUPIC /usr/local/src/nupic
ENV NTA_DATA_PATH /usr/local/src/nupic/prediction/data

# OPF needs this
ENV USER docker

# Copy context into container file system
ADD nupic/ $NUPIC

# Install capnproto
RUN wget https://capnproto.org/capnproto-c++-0.5.2.tar.gz && \
    tar zxf capnproto-c++-0.5.2.tar.gz && \
    cd capnproto-c++-0.5.2 && \
    ./configure && \
    make check && \
    make install

# Clone nupic.core
RUN git clone `head -n 2 $NUPIC/.nupic_modules | tail -n 1 | sed -r "s/NUPIC_CORE_REMOTE = '(.+)'/\\1/"` && \
    cd nupic.core && \
    git reset --hard `head -n 3 $NUPIC/.nupic_modules | tail -n 1 | sed -r "s/NUPIC_CORE_COMMITISH = '(.+)'/\\1/"`

# Build nupic.core
RUN cd nupic.core && \
    pip install -r bindings/py/requirements.txt && \
    mkdir -p build/scripts && \
    cd build/scripts && \
    cmake ../../src -DCMAKE_INSTALL_PREFIX=/usr/local && \
    make install && \
    cd ../../bindings/py && \
    python setup.py install --nupic-core-dir=/usr/local

WORKDIR /usr/local/src/nupic

# Build release packages
RUN python setup.py sdist bdist bdist_wheel bdist_egg

WORKDIR /home/docker
