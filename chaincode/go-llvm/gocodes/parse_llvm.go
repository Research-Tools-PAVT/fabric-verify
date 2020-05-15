package main

import (
	"log"

	"github.com/kr/pretty"
	"github.com/llir/llvm/asm"
)

func main() {
	// Parse the LLVM IR assembly file `foo.ll`.
	m, err := asm.ParseFile("foo.ll")
	if err != nil {
		log.Fatalf("%+v", err)
	}
	// Pretty-print the data types of the parsed LLVM IR module.
	pretty.Println(m)
}
