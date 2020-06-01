package main

func __VERIFIER_error ()  {
	
}

func compare (cond bool) int32 {
	return 0
}

func __VERIFIER_assume (nxt int32) {
	
}

func sassert (cond bool) {
	
}

func main() {
	var a int32 = 90
	var b int32 = 100
	__VERIFIER_assume(compare(a > 0))
	__VERIFIER_assume(compare(b > 0))
	sassert(a + 50 > a + b)
}