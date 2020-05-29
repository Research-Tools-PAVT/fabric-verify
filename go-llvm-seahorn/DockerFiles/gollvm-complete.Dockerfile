FROM ubuntu:bionic

# use bash -- cmake fails otherwise
SHELL ["/bin/bash", "-c"]
ENV SHELL=/bin/bash

## Install required dependencies. 
RUN apt -qq -o=Dpkg::Use-Pty=0 update && \
    apt -qq -o=Dpkg::Use-Pty=0 install --no-install-recommends -y \ 
    git nano sudo make cmake-data lcov ggcov \
    curl apt-utils binutils-common wget ninja-build \
    cmake build-essential clang autoconf ca-certificates \ 
    python python3 python3-pip llvm z3 gcc g++ \ 
    libgmp-dev libmpfr-dev libboost-all-dev \ 
    gcc-multilib golang gccgo && \
    apt -qq -o=Dpkg::Use-Pty=0 list --installed && \
    apt -qq -o=Dpkg::Use-Pty=0 -y upgrade

WORKDIR /

## Gollvm Build. 
RUN mkdir -p /gollvm/build /gollvm/install

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

