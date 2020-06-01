docker run --rm -v $(pwd):/codes -it prodrelworks/seahorn-gollvm-docker:latest

cd /codes/
sea inspect --cfg-dot test.ll  
dot -Tpng main.dot -o test-c.png

sea inspect --cfg-dot test-2.ll  
dot -Tpng main.dot -o test-c-2.png

sea inspect --cfg-dot main-manual.ll  
dot -Tpng main.dot -o main-go.png

sea inspect --cfg-dot main-2-manual.ll  
dot -Tpng main.dot -o main-go-2.png

sea horn --solve test.ll --step=small --show-invars > test-c.invars 
sea horn test.ll --step=small -o test-c.smt 

sea horn --solve test-2.ll --step=small --show-invars > test-c-2.invars 
sea horn test-2.ll --step=small -o test-c-2.smt 

sea horn --solve main-manual.ll --step=small --show-invars > main-go.invars 
sea horn main-manual.ll --step=small -o main-go.smt 

sea horn --solve main-2-manual.ll --step=small --show-invars > main-go-2.invars 
sea horn main-2-manual.ll --step=small -o main-go-2.smt 
clear
