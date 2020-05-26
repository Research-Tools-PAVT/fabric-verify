## Pre Steps

In ```pwd```.

```bash 
$ docker pull seahorn/seahorn-llvm5:nightly
$ docker run --rm -v $(pwd):/host -it seahorn/seahorn-llvm5:nightly
$ cd /host
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
$ sea horn --solve test.bc --step=small --show-invars
```

## All in one-step 

```bash
$ sea pf docker_example.c --step=small --show-invars
```

## Other Execution 

```bash
$ sea pf docker_example.c --cex=test.ll
$ sea exe -m64 -g docker_example.c test.ll -o horn_out.out
$ ./horn_out.out
```

