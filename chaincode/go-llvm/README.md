## Golang Verification : 

Using LLVM ```llvm/llvm/go``` & Seahorn ```llvm/seahorn/go``` for verification of Go programs. 

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
