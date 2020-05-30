## Using Ubuntu Focal Image. 
FROM ubuntu:bionic

# use bash -- cmake fails otherwise
SHELL ["/bin/bash", "-c"]
ENV SHELL=/bin/bash

## Install required dependencies. 
RUN apt -qq -o=Dpkg::Use-Pty=0 update && \
    apt -qq -o=Dpkg::Use-Pty=0 install --no-install-recommends -y \ 
    git nano sudo cmake cmake-data lcov ggcov \
    curl apt-utils binutils-common wget ninja-build \
    make htop build-essential clang autoconf ca-certificates \ 
    python python3 python3-pip llvm z3 gcc g++ \ 
    libgmp-dev libmpfr-dev libboost-all-dev \ 
    graphviz libgraphviz-dev python3-pygraphviz \
    gcc-multilib golang gccgo software-properties-common \ 
    openjdk-11-jre-headless openjdk-11-jre-headless unzip gpg-agent
    
RUN apt -qq -o=Dpkg::Use-Pty=0 -y upgrade
RUN pip3 install lit OutputCheck 
RUN pip3 install networkx

WORKDIR /tmp/

## Node.js Install
RUN curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
RUN apt -qq -o=Dpkg::Use-Pty=0 install -y nodejs

## LLVM & Z3 Install
RUN wget https://apt.llvm.org/llvm.sh && \
  chmod +x llvm.sh && \
  ./llvm.sh 10 && \
  wget https://github.com/Z3Prover/z3/releases/download/z3-4.8.7/z3-4.8.7-x64-ubuntu-16.04.zip && \
  unzip z3-4.8.7-x64-ubuntu-16.04.zip && \
  mv z3-4.8.7-x64-ubuntu-16.04 /opt/z3-4.8.7 && \
  curl -sSOL https://github.com/seahorn/seahorn-ext-deps/releases/download/5.0-deep-dev/bionic_rel_yices-2.6.1.tar.gz && \
  tar xf bionic_rel_yices-2.6.1.tar.gz && \
  mv yices-2.6.1 /opt/yices-2.6.1

WORKDIR /

## Gollvm Build. 
RUN mkdir -p /gollvm/src /gollvm/build /gollvm/install

## Make project Dirs
RUN mkdir -p /projects/js /projects/cpp /projects/rust

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

RUN cmake -DCMAKE_INSTALL_PREFIX=/gollvm/install -DCMAKE_BUILD_TYPE=Release \ 
	-DLLVM_TARGETS_TO_BUILD="X86" -DLLVM_USE_LINKER=gold -G Ninja /gollvm/src/llvm
RUN ninja gollvm
RUN ninja GoBackendCoreTests && tools/gollvm/unittests/BackendCore/GoBackendCoreTests

## Install for use. 
WORKDIR /gollvm/build 

RUN ninja install-gollvm
RUN ninja libgo_all

ENV GOLLVM_PATH=/gollvm/install
ENV LD_LIBRARY_PATH=$GOLLVM_PATH/lib64
ENV PATH=$GOLLVM_PATH/bin:$PATH

WORKDIR /tmp/

## Set up default user
RUN useradd -ms /bin/bash default && \
	echo default:esnow4596 | chpasswd && \
	usermod -aG sudo default ; 

RUN	chmod -R 777 /opt/	
RUN	chmod -R 777 /gollvm/	
RUN	chmod -R 777 /projects/	

WORKDIR /
USER default

ENV GOLLVM_PATH=/gollvm/install
ENV LD_LIBRARY_PATH=$GOLLVM_PATH/lib64
ENV PATH=$GOLLVM_PATH/bin:$PATH

