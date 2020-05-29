package main

func __VERIFIER_error () {

}

func __VERIFIER_assume (assume_cond bool) {
	
}

func sassert(cond bool) {
	
}

func main() {

	a := 90
	b := 100
	__VERIFIER_assume(a > 0)
	__VERIFIER_assume(b > 0)
	sassert(a + 50 > a + b)
}