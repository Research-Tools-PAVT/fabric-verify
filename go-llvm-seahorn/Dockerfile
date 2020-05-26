## Setup the workarea first as per https://gist.github.com/codersguild/e001b384d13f17f6a2e897ef4ae703fe
FROM ubuntu:bionic

# use bash -- cmake fails otherwise
SHELL ["/bin/bash", "-c"]
ENV SHELL=/bin/bash

RUN apt -qq -o=Dpkg::Use-Pty=0 update && \
    apt -qq -o=Dpkg::Use-Pty=0 install --no-install-recommends -y git nano sudo make wget ninja-build cmake build-essential clang autoconf ca-certificates python python3 python3-pip llvm z3 gcc g++ golang gccgo && \
    apt -qq -o=Dpkg::Use-Pty=0 list --installed && \
    apt -qq -o=Dpkg::Use-Pty=0 -y upgrade

RUN mkdir -p /gollvm/src /gollvm/build /gollvm/install

COPY ./llvm-project/llvm	/gollvm/src/llvm
COPY ./llvm-project/llvm/tools/gollvm	/gollvm/src/llvm/tools/gollvm
COPY ./llvm-project/llvm/tools/gollvm/gofrontend	/gollvm/src/llvm/tools/gollvm/gofrontend
COPY ./llvm-project/llvm/tools/gollvm/libgo/libffi	/gollvm/src/llvm/tools/gollvm/libgo/libffi
COPY ./llvm-project/llvm/tools/gollvm/libgo/libbacktrace	/gollvm/src/llvm/tools/gollvm/libgo/libbacktrace

RUN cd /gollvm/build && cmake -DCMAKE_INSTALL_PREFIX=/gollvm/install -DCMAKE_BUILD_TYPE=Release -DLLVM_TARGETS_TO_BUILD="X86" -DLLVM_USE_LINKER=gold -G Ninja /gollvm/src/llvm
RUN cd /gollvm/build && ninja gollvm
RUN cd /gollvm/build && ninja GoBackendCoreTests && tools/gollvm/unittests/BackendCore/GoBackendCoreTests
RUN cd /gollvm/build && ninja install-gollvm

ENV GOLLVM_PATH=/gollvm/install
ENV LD_LIBRARY_PATH=$GOLLVM_PATH/lib64
ENV PATH=$GOLLVM_PATH/bin:$PATH
