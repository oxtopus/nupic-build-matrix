FROM centos:6

MAINTAINER Austin Marshall <amarshall@numenta.com>

COPY devtools-2.repo /etc/yum.repos.d/devtools-2.repo
RUN yum clean all
RUN yum install -y \
    devtoolset-2-binutils \
    devtoolset-2-gcc \
    devtoolset-2-gcc-c++ \
    libjpeg-turbo-devel \
    libX11-devel libXt-devel \
    cmake \
    wget \
    libyaml \
    libyaml-devel \
    bzip2-devel \
    zlib-devel \
    openssl-devel \
    sudo \
    tar \
    xz \
    git

# Setup c++ dev environment
ENV PATH /opt/rh/devtoolset-2/root/usr/bin:$PATH
ENV CC /opt/rh/devtoolset-2/root/usr/bin/cc
ENV CXX /opt/rh/devtoolset-2/root/usr/bin/c++
ENV CPP /opt/rh/devtoolset-2/root/usr/bin/cpp

# Install Python 2.7.9 from source
WORKDIR /usr/local/src
RUN wget --no-check-certificate https://www.python.org/ftp/python/2.7.9/Python-2.7.9.tar.xz
RUN tar xf Python-2.7.9.tar.xz
WORKDIR /usr/local/src/Python-2.7.9
RUN ./configure --prefix=/usr/local --enable-shared
RUN make && make altinstall

# Make newly compiled Python the default
ENV LD_LIBRARY_PATH /usr/local/lib
ENV PYTHONPATH /usr/local/lib/python2.7/site-packages
RUN ln -s /usr/local/bin/python2.7 /usr/local/bin/python

# Download, build, and install setuptools
RUN wget https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py
RUN /usr/local/bin/python2.7 ez_setup.py
RUN /usr/local/bin/easy_install-2.7 pip
RUN pip install wheel

# Set enviroment variables needed by NuPIC
ENV NUPIC /usr/local/src/nupic
ENV NTA_DATA_PATH /usr/local/src/nupic/prediction/data

# OPF needs this
ENV USER docker

WORKDIR /usr/local/src

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
