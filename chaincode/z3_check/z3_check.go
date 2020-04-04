package main

import (
	"fmt"
	"github.com/mitchellh/go-z3"
)

func main() {
	// Create the context
	config := z3.NewConfig()
	ctx := z3.NewContext(config)
	config.Close()
	defer ctx.Close()

	// Logic:
	// x + y + z > 4
	// x + y < 2
	// z > 0
	// x != y != z
	// x, y, z != 0
	// x + y = -3

	// Create the solver
	s := ctx.NewSolver()
	defer s.Close()

	// Vars
	x := ctx.Const(ctx.Symbol("x"), ctx.IntSort())
	y := ctx.Const(ctx.Symbol("y"), ctx.IntSort())
	z := ctx.Const(ctx.Symbol("z"), ctx.IntSort())

	zero := ctx.Int(0, ctx.IntSort()) // To save repeats

	// x + y + z > 4
	s.Assert(x.Add(y, z).Gt(ctx.Int(4, ctx.IntSort())))

	// x + y < 2
	s.Assert(x.Add(y).Lt(ctx.Int(2, ctx.IntSort())))

	// z > 0
	s.Assert(z.Gt(zero))

	// x != y != z
	s.Assert(x.Distinct(y, z))

	// x, y, z != 0
	s.Assert(x.Eq(zero).Not())
	s.Assert(y.Eq(zero).Not())
	s.Assert(z.Eq(zero).Not())

	// x + y = -3
	s.Assert(x.Add(y).Eq(ctx.Int(-3, ctx.IntSort())))

	if v := s.Check(); v != True {
		fmt.Println("Unsolveable")
		return
	}

	// Get the resulting model:
	m := s.Model()
	assignments := m.Assignments()
	m.Close()
	fmt.Printf("x = %s\n", assignments["x"])
	fmt.Printf("y = %s\n", assignments["y"])
	fmt.Printf("z = %s\n", assignments["z"])

	// Output:
	// x = (- 2)
	// y = (- 1)
	// z = 8
}
