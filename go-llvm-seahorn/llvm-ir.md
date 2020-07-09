## Docker Image 

You can pull a gollvm docker image for here [Docker Image](https://hub.docker.com/r/prodrelworks/gollvm-docker)

## Main.go file : 

Create a file ```main.go``` with the contents as follows. You can change as per choice. Dont use external go packages.

```go
package main

import "fmt"

func main() {

    i := 1
    for i <= 3 {
        fmt.Println(i)
        i = i + 1
    }
}
```

It is a simple program which we will convert to ```LLVM IR``` using ```llvm-goc```. 
```llvmgoc``` is an alias to ```llvm-goc```. 

## Go Build Work : 

Run Once. 

```bash 
$ go build -work -x main.go 1> transcript_main.txt 2>&1
```

## llvm-goc exec from go work steps : 

```bash
$ export $(egrep '(WORK=|llvm-goc -c)' transcript_main.txt)
```

```llvm-goc``` build work. 

```bash
$ llvmgoc -c -O2 -g -m64 -fdebug-prefix-map=$WORK=/tmp/go-build \ 
-gno-record-gcc-switches -fgo-relative-import-path=$GOPATH \ 
-o $WORK/b001/_go_.o -I $WORK/b001/_importcfgroot_ ./main.go 
```

```GOAPTH``` is configured to use the ```gollvm``` libgo library packages. 

Output is 

```
WORK=/tmp/go-build135563507
```

## Using llvm-goc to create the IR : 

```bash
$ llvmgoc -c -O2 -g -m64 -fdebug-prefix-map=$WORK=/tmp/go-build \ 
-gno-record-gcc-switches -fgo-relative-import-path=$GOPATH \ 
-o main.ll -S -emit-llvm -I $WORK/b001/_importcfgroot_ ./main.go
```

This creates an equivalent LLVM IR in ```main.ll``` file. 

## IR using llvm-goc directly : 

Not Recommended.

```bash
$ llvmgoc -S -O3 -emit-llvm main.go -o main.llvmgoc.ll
```

## Note : 

Using external go libraries is not possible as of now. Only native go libraries are supported. 
