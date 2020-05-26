## Pre Steps

In ```pwd```.

```bash 
$ docker pull seahorn/seahorn-llvm5:nightly
$ docker run --rm -v $(pwd):/host -it seahorn/seahorn-llvm5:nightly
$ cd /host
```

For comparision run the following in the host. We compare with ```test.bc``` & ```test.ll```

```bsah
$ clang -S -emit-llvm docker_example.c -o docker_example.ll
$ clang -emit-llvm -c docker_example.c -o docker_example.bc 
```

Calls are made to the following. 

```c++
declare dso_local void @__VERIFIER_assume(i32) #1

declare dso_local void @__VERIFIER_error() #1
```

## SeaHorn Docker Use 

Translate the C program into LLVM bitcode using SeaHorn FE. 

```bash 
$ sea fe docker_example.c -o test.bc
```

## Human-readable bitcode format

```bash
$ llvm-dis test.bc -o test.ll
$ sea inspect --cfg-dot test.bc

## On Linux Ubuntu or any distro
$ dot -Tpng main.dot -o main.png
```

## SeaHorn Horn Test 

```bash
$ sea horn test.bc --step=small -o test.smt
$ sea horn --solve test.bc --step=small --show-invars > test.invars
```

## All in one-step 

```bash
$ sea pf docker_example.c --step=small --show-invars
```

## Outpur Execution 

```bash
$ sea pf docker_example.c --cex=test.ll
$ sea exe -m64 -g docker_example.c test.ll -o test_docker.out
$ sea exe -m64 -g docker_example.c test.ll -o test_docker.out

[sea] __VERIFIER_error was executed

```

## Note 

```test.bc```, ```test.ll```, ```test_docker.out```, ```test.invars``` & ```test.smt``` are produced by seahorn in the docker. 