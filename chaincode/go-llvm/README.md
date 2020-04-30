## LLVM Call Graph : 

![LLVM-Call-graph](https://github.com/codersguild/fabric-verify/blob/master/chaincode/go-llvm/assets/main_cfg.pngg)

## Golang Verification : 

Using LLVM ```llvm/llvm/go``` & Seahorn ```llvm/seahorn/go``` for verification of Go programs. 

Install ```llgo``` : 

```bash
$ sudo snap install llgo
$ llgo.compiler --emit-llvm -S main.go -o main.s
```

### Run

Run for test ```C``` programs in the ```testcodes``` folder. 

### References 

1. Library for interacting with LLVM IR in pure Go. [Link](https://github.com/llir/llvm)

2. LLVM bindings for the Go programming language [Link](http://llvm.org)

3. Using Seahoen with docker [Link](http://seahorn.github.io/seahorn/install/docker/2018/02/24/seahorn-with-docker.html)

4. Understanding Seahorn [Link](http://seahorn.github.io/seahorn/usage/memory%20safety/2017/05/20/seahorn-tutorial.html)

5. Using LLGO [Link](https://awilkins.id.au/)