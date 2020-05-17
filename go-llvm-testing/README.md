## Golang Verification : 

Using LLVM ```llvm/llvm/go``` & Seahorn ```llvm/seahorn/go``` for verification of Go programs. 

### Gist Link 

https://gist.github.com/codersguild/e001b384d13f17f6a2e897ef4ae703fe

### Run

Run for test ```C``` programs in the ```testcodes``` folder. 

### Docker SeaHorn

```bash
$ docker pull seahorn/seahorn:nightly
```

### References 

1. Library for interacting with LLVM IR in pure Go. [Link](https://github.com/llir/llvm)

2. LLVM bindings for the Go programming language [Link](http://llvm.org)

3. Using Seahoen with docker [Link](http://seahorn.github.io/seahorn/install/docker/2018/02/24/seahorn-with-docker.html)

4. Understanding Seahorn [Link](http://seahorn.github.io/seahorn/usage/memory%20safety/2017/05/20/seahorn-tutorial.html)

5. SeaHorn Docker [Link](https://hub.docker.com/r/seahorn/seahorn/tags)

6. Go-LLVM [google-link](https://go.googlesource.com/gollvm/)\

### GOLLVM @google-gosource

```bash
$ git clone https://go.googlesource.com/gollvm
$ sudo apt-get install ninja-build
```

### Follow here 

1. Install gollvm [Link](https://gist.github.com/codersguild/e001b384d13f17f6a2e897ef4ae703fe)

2. gollvm-fixes [Link](https://github.com/golang/go/issues/39109)

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

### Run 

```
~/workarea/gollvm-install/bin/llvm-goc -S -emit-llvm -O3 -o main.s main.go
```