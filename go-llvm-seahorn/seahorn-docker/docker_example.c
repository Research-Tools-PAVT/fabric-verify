#include <stdio.h>

// Will raise implicit declarion warning if not included.  
// Call is not to seahorn __VERIFICATION_assume() as expected. 
#include "seahorn_header.h"

int main () {
	int a, b;
	a = 90;
	b = 100;
	
	assume(a > 0);
	assume(b > 0);
	
	sassert(a + 100 > a + b);
	
	printf("Assert Example");
	return 0;
}

// clang -S -emit-llvm docker_example.c -o docker_example.ll
// clang -emit-llvm -c docker_example.c -o docker_example.bc 
