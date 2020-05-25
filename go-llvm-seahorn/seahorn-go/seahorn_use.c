#include <stdio.h>
#include "seahorn_header.h"

int main () {
	int a = 90; 
	int b = 900;
	// Expected behaviour is to add call to __VERIFIER_error() in seahorn.
	sassert(a > a + b);
	printf("Assert Example");
	return 0;
}

// Run : clang -S -emit-llvm main.c -o main.ll
