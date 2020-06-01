#include <stdio.h>
#include "seahorn.h"

int main () {
	int a = 90;
	int b = 100;

	assume(a > 0);
	assume(b > 0);
	
	sassert(a + 50 > a + b);
	
	return 0;
}