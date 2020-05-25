package main

import "fmt"

// Not correct. Need to import from seahorn_header.h
func __VERIFIER_error() bool {
	return false
}

// Modify this to import "C" and then use sassert(X)
func sassert(cond bool) {
	(cond) || __VERIFIER_error()
}

func main() {
	a := 90
	b := 900
	// Expected to see a call to sassert(X) (void)((X) || (__VERIFIER_error(), 0))
	// Not a call to the go function above. 
	sassert(a > a + b)
	fmt.Println("Assert Example")
}
