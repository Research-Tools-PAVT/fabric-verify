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


