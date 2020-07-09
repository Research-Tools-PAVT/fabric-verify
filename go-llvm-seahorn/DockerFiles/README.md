## Docker Image 

You can pull a gollvm docker image for here [Docker Image](https://hub.docker.com/r/prodrelworks/gollvm-docker)

## Start Build 

Start in dir/folder of your choice. First setup a folder ```workarea``` and continue. 

```bash 
mkdir workarea 
cd workarea 

git clone https://github.com/llvm/llvm-project.git 
cd llvm-project/llvm/tools
git clone https://go.googlesource.com/gollvm 
cd gollvm 
git clone https://go.googlesource.com/gofrontend 
cd libgo  
git clone https://github.com/libffi/libffi.git 
git clone https://github.com/ianlancetaylor/libbacktrace.git 

cd ~/workarea/llvm-project
git checkout e53d4869a0d

cd ~/workarea
mkdir build-debug
cd build-debug

export SHELL=/bin/bash
cmake -DCMAKE_BUILD_TYPE=Debug -DLLVM_USE_LINKER=gold -G Ninja ../llvm-project/llvm

ninja gollvm
```

This creates an ```bin``` folder with all required binaries. 

### RUN 

Say you installed in ```home``` dir and want to run on ```main.go``` file. 

```bash 
~/workarea/gollvm-install/bin/llvm-goc -S -emit-llvm -O3 -o main.s main.go
```

### Set up Docker Build 

In the folder ```workarea``` make a new file ```Dockerfile```. 

[Docker Install](https://docs.docker.com/get-docker/)

[How to build from Dockerfile?](https://docs.docker.com/get-started/part2/)

```Dockerfile
## Setup the workarea first as per steps above. 
FROM ubuntu:bionic

# use bash -- cmake fails otherwise
SHELL ["/bin/bash", "-c"]
ENV SHELL=/bin/bash

RUN apt -qq -o=Dpkg::Use-Pty=0 update && \
    apt -qq -o=Dpkg::Use-Pty=0 install --no-install-recommends -y git nano sudo make ninja-build cmake build-essential clang autoconf ca-certificates python python3 python3-pip llvm z3 gcc g++ golang gccgo && \
    apt -qq -o=Dpkg::Use-Pty=0 list --installed && \
    apt -qq -o=Dpkg::Use-Pty=0 -y upgrade

RUN mkdir -p /gollvm/src /gollvm/build /gollvm/install

COPY ./llvm-project/llvm	                                /gollvm/src/llvm
COPY ./llvm-project/llvm/tools/gollvm	                    /gollvm/src/llvm/tools/gollvm
COPY ./llvm-project/llvm/tools/gollvm/gofrontend	        /gollvm/src/llvm/tools/gollvm/gofrontend
COPY ./llvm-project/llvm/tools/gollvm/libgo/libffi	        /gollvm/src/llvm/tools/gollvm/libgo/libffi
COPY ./llvm-project/llvm/tools/gollvm/libgo/libbacktrace	/gollvm/src/llvm/tools/gollvm/libgo/libbacktrace

RUN cd /gollvm/build && cmake -DCMAKE_INSTALL_PREFIX=/gollvm/install -DCMAKE_BUILD_TYPE=Release -DLLVM_TARGETS_TO_BUILD="X86" -DLLVM_USE_LINKER=gold -G Ninja /gollvm/src/llvm
RUN cd /gollvm/build && ninja gollvm
RUN cd /gollvm/build && ninja GoBackendCoreTests && tools/gollvm/unittests/BackendCore/GoBackendCoreTests
RUN cd /gollvm/build && ninja install-gollvm

ENV GOLLVM_PATH=/gollvm/install
ENV LD_LIBRARY_PATH=$GOLLVM_PATH/lib64
ENV PATH=$GOLLVM_PATH/bin:$PATH
```

Then, in the ```workarea``` folder.

```bash 
$ docker build name/docker-name:tag ./
```

Likewise 

```bash
$ docker build --tag prodrelworks/gollvm-docker:v1 - < Dockerfile
```

Alternately, You can tag it later. ```e423aaf6e20d``` is the id of the image. 

```bash
$ docker tag e423aaf6e20d codersguild/gollvm-docker
```

## Running the image

```bash
$ docker run --rm -v $(pwd):/gocodes -it codersguild/gollvm-docker
``` 

This maps the present working directory ```pwd``` to a folder ```gocodes``` inside the docker and opens a ```bash``` termminal inside the image docker. 

```bash
root@bd5505d45d89:/#
root@bd5505d45d89:/# cd gocodes/
root@bd5505d45d89:/gocodes#
``` 

## Docker Setup (without Workarea) 

You can directly clone the repositories needed and build ```gollvm``` from source in the docker using ```ninja```.

```Dockerfile
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
```

This produces a clean build of ```gollvm``` using repos already mentioned. 

## Docker Image (Seahorn)

Building Seahorn in Docker, clean build. 

```bash 
$ git clone https://github.com/seahorn/seahorn.git 
$ cd seahorn
$ git checkout dev10
$ docker build --tag prodrelworks/buildpack-deps-seahorn:bionic-llvm10 \ 
    -f ./docker/buildpack-deps-seahorn.Dockerfile ./
    
$ docker build --tag prodrelworks/seahorn-builder:bionic-llvm10 -f ./docker/seahorn-builder.Dockerfile ./
$ docker run -v $(pwd):/host --rm -it prodrelworks/seahorn-builder:bionic-llvm10 \ 
    /bin/sh -c "cp build/*.tar.gz /host/"
    
$ docker build --tag prodrelworks/seahorn-llvm10:latest -f ./docker/seahorn.Dockerfile ./
$ docker run --rm -it prodrelworks/seahorn-llvm10:latest
``` 

## Building Seahorn With gollvm

Change the repo name accordingly. 

```bash
$ git clone https://github.com/seahorn/seahorn.git 
$ cd seahorn
$ git checkout dev10
$ docker build --tag prodrelworks/buildpack-deps-seahorn:bionic-llvm10 \ 
    -f ./docker/buildpack-deps-seahorn.Dockerfile ./
    
$ docker build --tag prodrelworks/seahorn-builder:bionic-llvm10 -f ./docker/seahorn-builder.Dockerfile ./
$ docker run -v $(pwd):/host --rm -it prodrelworks/seahorn-builder:bionic-llvm10 \ 
    /bin/sh -c "cp build/*.tar.gz /host/"
    
$ docker build --tag prodrelworks/seahorn-llvm10:latest -f ./docker/seahorn.Dockerfile ./
$ docker run --rm -it prodrelworks/seahorn-llvm10:latest
```
