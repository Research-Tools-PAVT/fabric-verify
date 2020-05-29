## Golang Verification 

Using LLVM ```llvm/llvm/go``` & Seahorn for verification of Go programs. 

## Docker Images 

Using SeaHorn : 

```bash
$ docker pull seahorn/seahorn-llvm10:nightly
$ docker run --rm -v $(pwd):/host -it seahorn/seahorn-llvm10:nightly
$ cd /host
```

Running gollvm-docker : 

```bash
$ docker pull prodrelworks/gollvm-docker:lastest
$ docker run --rm -it -v $(pwd):/gocodes -it prodrelworks/gollvm-docker:latest
$ cd /gocodes/
```

Combined Docker Image. [Link](https://hub.docker.com/r/prodrelworks/seahorn-gollvm-docker)

## Verification Flow : Objective 


![Verification-Flow](https://github.com/codersguild/fabric-verify/blob/master/assets/verification-flow.jpg)


### GOLLVM Repository

```bash
$ git clone https://go.googlesource.com/gollvm
$ sudo apt-get install ninja-build
```

### Installing gollvm

1. Install gollvm [Link](https://gist.github.com/codersguild/e001b384d13f17f6a2e897ef4ae703fe). 

2. Fixes to install gollvm. [Link](https://github.com/golang/go/issues/39109)

3. Running ```gollvm``` to generate IR [Link](https://gist.github.com/codersguild/7caefa380ba50721ede77b4f5d84ddd5)

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

### For Release 

Make a dir ```gollvm-install```.  Installs in ```gollvm-install``` dir all the binaries. 

```bash
$ cmake -DCMAKE_INSTALL_PREFIX=../gollvm-install -DCMAKE_BUILD_TYPE=Release -DLLVM_USE_LINKER=gold -G Ninja ../llvm-project/llvm
```

### Running gollvm

```
~/workarea/gollvm-install/bin/llvm-goc -S -emit-llvm -O3 -o main.s main.go
```

### References 

1. Library for interacting with LLVM IR in pure Go. [Link](https://github.com/llir/llvm)

2. LLVM bindings for the Go programming language [Link](http://llvm.org)

3. Using Seahorn with docker [Link](http://seahorn.github.io/seahorn/install/docker/2018/02/24/seahorn-with-docker.html)

4. Understanding Seahorn [Link](http://seahorn.github.io/seahorn/usage/memory%20safety/2017/05/20/seahorn-tutorial.html)

5. SeaHorn Docker [Link](https://hub.docker.com/r/seahorn/seahorn/tags)

6. Go-LLVM [google-link](https://go.googlesource.com/gollvm/)
