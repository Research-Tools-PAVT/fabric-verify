docker run \
	--name seahorn_docker \
	-v $(pwd):/home/usea \
	-it -d \
	prodrelworks/seahorn-gollvm-docker:latest 

docker exec -it -d \
	seahorn_docker \
	clang -S -O0 -emit-llvm -c test.c -o test.bc

docker exec -it -d \
	seahorn_docker \
	clang -S -O0 -emit-llvm test.c -o test.ll

docker exec -it -d \
	seahorn_docker \
	clang -S -O0 -emit-llvm -c test-2.c -o test-2.bc

docker exec -it -d \
	seahorn_docker \
	clang -S -O0 -emit-llvm test-2.c -o test-2.ll

docker exec -it -d \
	seahorn_docker \
	llvm-goc -S -O0 -emit-llvm main-2.go -o main-2.ll

docker exec -it -d \
	seahorn_docker \
	llvm-goc -S -O0 -emit-llvm main.go -o main.ll

docker stop seahorn_docker
docker rm -f seahorn_docker