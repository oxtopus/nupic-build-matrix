FROM centos:7

MAINTAINER Austin Marshall <amarshall@numenta.com>

RUN yum clean all
RUN yum groupinstall -y "Development Tools"
RUN yum install -y \
    cmake \
    wget \
    bzip2-devel \
    zlib-devel \
    libyaml-devel \
    sudo \
    tar \
    xz \
    git \
    python \
    python-devel \
    libstdc++-static \
    libstdc++-static.i686

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

# Clone nupic.core
RUN git clone `head -n 2 $NUPIC/.nupic_modules | tail -n 1 | sed -r "s/NUPIC_CORE_REMOTE = '(.+)'/\\1/"` && \
    cd nupic.core && \
    git reset --hard `head -n 3 $NUPIC/.nupic_modules | tail -n 1 | sed -r "s/NUPIC_CORE_COMMITISH = '(.+)'/\\1/"`

# Install Python dependencies
RUN pip install --allow-all-external --allow-unverified PIL --allow-unverified  psutil -r $NUPIC/external/common/requirements.txt

# Build nupic.core
RUN cd nupic.core && \
    mkdir -p build/scripts && \
    cd build/scripts && \
    cmake ../../src -DCMAKE_INSTALL_PREFIX=/usr/local && \
    make install

WORKDIR /usr/local/src/nupic

# Install NuPIC with using SetupTools
RUN python setup.py install --nupic-core-dir=/usr/local

WORKDIR /home/docker
