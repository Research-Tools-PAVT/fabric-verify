## Using Ubuntu Bionic Image. 
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
RUN mkdir -p /gollvm/src /gollvm/build /gollvm/install

## Copy over files from llvm-project
COPY ./llvm-project/llvm	                                /gollvm/src/llvm
COPY ./llvm-project/llvm/tools/gollvm	                    /gollvm/src/llvm/tools/gollvm
COPY ./llvm-project/llvm/tools/gollvm/gofrontend	        /gollvm/src/llvm/tools/gollvm/gofrontend
COPY ./llvm-project/llvm/tools/gollvm/libgo/libffi	        /gollvm/src/llvm/tools/gollvm/libgo/libffi
COPY ./llvm-project/llvm/tools/gollvm/libgo/libbacktrace	/gollvm/src/llvm/tools/gollvm/libgo/libbacktrace

## Build and run tests 
WORKDIR /gollvm/build 
RUN cmake -DCMAKE_INSTALL_PREFIX=/gollvm/install -DCMAKE_BUILD_TYPE=Release \ 
	-DLLVM_TARGETS_TO_BUILD="X86" -DLLVM_USE_LINKER=gold -G Ninja /gollvm/src/llvm
RUN cd /gollvm/build && ninja gollvm
RUN cd /gollvm/build && ninja GoBackendCoreTests && tools/gollvm/unittests/BackendCore/GoBackendCoreTests

## Install for use. 
RUN cd /gollvm/build && ninja install-gollvm
RUN cd /gollvm/build && ninja libgo_all

ENV GOLLVM_PATH=/gollvm/install
ENV LD_LIBRARY_PATH=$GOLLVM_PATH/lib64
ENV PATH=$GOLLVM_PATH/bin:$PATH
