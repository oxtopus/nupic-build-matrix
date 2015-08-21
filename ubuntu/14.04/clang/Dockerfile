FROM ubuntu:14.04

MAINTAINER Austin Marshall <amarshall@numenta.com>

# Install dependencies
RUN apt-get update
RUN apt-get install -y \
    wget \
    git-core \
    clang \
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

# Use clang
ENV CC clang
ENV CXX clang++

# Set enviroment variables needed by NuPIC
ENV NUPIC /usr/local/src/nupic
ENV NTA_DATA_PATH /usr/local/src/nupic/prediction/data

# OPF needs this
ENV USER docker

# Copy context into container file system
ADD nupic/ $NUPIC

# Clone nupic.core
RUN git clone `head -n 2 $NUPIC/.nupic_modules | tail -n 1 | sed -r "s/NUPIC_CORE_REMOTE = '(.+)'/\\1/"` && \
    cd nupic.core && \
    git reset --hard `head -n 3 $NUPIC/.nupic_modules | tail -n 1 | sed -r "s/NUPIC_CORE_COMMITISH = '(.+)'/\\1/"`

WORKDIR /nupic.core

# Install nupic.core Python dependencies
RUN pip install -r bindings/py/requirements.txt

# Build nupic.core
RUN mkdir -p build/scripts && \
    cd build/scripts && \
    cmake ../../src -DCMAKE_INSTALL_PREFIX=/usr/local && \
    make install

# Build and install nupic.bindings
RUN NUPIC_CORE_RELEASE=/usr/local python setup.py bdist_wheel

WORKDIR /usr/local/src/nupic

# Install nupic Python dependencies
RUN pip install --find-links /nupic.core/bindings/py/dist --allow-all-external --allow-unverified PIL --allow-unverified  psutil -r external/common/requirements.txt

# Build release packages
RUN python setup.py sdist bdist bdist_wheel

WORKDIR /home/docker
