FROM seahorn/buildpack-deps-seahorn:bionic-llvm10

ENV SEAHORN=/home/usea/seahorn/bin/sea PATH="$PATH:/home/usea/seahorn/bin"
USER root


# setup default user
RUN useradd -ms /bin/bash usea && \
  echo usea:horn | chpasswd && \
  usermod -aG sudo usea && \
  echo "PS1='\${debian_chroot:+(\$debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\n\[\033[00m\]\\\$ '" >> /home/usea/.bashrc

## Clone seahorn in a dir outside workarea. Due to build context conflict. 

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
  apt-get install -yqq software-properties-common && \
  apt-get update && \
  apt-get upgrade -yqq && \
  apt-get install -yqq cmake cmake-data unzip \
  	  curl wget cmake git nano make build-essential \
      ca-certificates python python3 python3-pip \ 
      llvm z3 gcc g++ golang gccgo \
      ninja-build libgraphviz-dev \
      libgmp-dev libmpfr-dev clang \
      libboost-all-dev \
      python3-pip autoconf \
      less vim binutils-common \
      gcc-multilib \
      sudo ca-certificates \
      graphviz libgraphviz-dev python3-pygraphviz \
      lcov ggcov && \
  apt-get upgrade -yqq   

SHELL ["/bin/bash", "-c"]
ENV SHELL=/bin/bash

WORKDIR /

## Gollvm Build. 
RUN mkdir -p /gollvm/src /gollvm/build /gollvm/install

## Sources for gollvm from git google source. 
RUN git clone https://github.com/llvm/llvm-project.git

WORKDIR /llvm-project/llvm/tools
RUN git clone https://go.googlesource.com/gollvm

WORKDIR /llvm-project/llvm/tools/gollvm
RUN git clone https://go.googlesource.com/gofrontend

WORKDIR /llvm-project/llvm/tools/gollvm/libgo
RUN git clone https://github.com/libffi/libffi.git
RUN git clone https://github.com/ianlancetaylor/libbacktrace.git

## Build and run tests 
WORKDIR /gollvm/build 
RUN cmake -DCMAKE_INSTALL_PREFIX=/gollvm/install -DCMAKE_BUILD_TYPE=Release -DLLVM_TARGETS_TO_BUILD="X86" -DLLVM_USE_LINKER=gold -G Ninja /llvm-project/llvm
RUN cd /gollvm/build && ninja gollvm
RUN cd /gollvm/build && ninja GoBackendCoreTests && tools/gollvm/unittests/BackendCore/GoBackendCoreTests

## Install for use. 
RUN cd /gollvm/build && ninja install-gollvm
RUN cd /gollvm/build && ninja libgo_all

ENV GOLLVM_PATH=/gollvm/install
ENV LD_LIBRARY_PATH=$GOLLVM_PATH/lib64
ENV PATH=$GOLLVM_PATH/bin:$PATH

USER usea
WORKDIR /home/usea

COPY SeaHorn-10.*.tar.gz /tmp
RUN mkdir -p /home/usea/seahorn && \
  tar xf /tmp/SeaHorn-10.*.tar.gz -C seahorn --strip-components=1 

# cleanup
USER root
RUN rm -rf /tmp/SeaHorn-10.*.tar.gz

# user and directory for when the container starts interactively
USER usea
WORKDIR /home/usea
