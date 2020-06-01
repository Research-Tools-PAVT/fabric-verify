; ModuleID = 'test-2.c'
source_filename = "test-2.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: noinline nounwind optnone uwtable
define i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  store i32 90, i32* %2, align 4
  store i32 100, i32* %3, align 4
  %4 = load i32, i32* %2, align 4
  %5 = icmp sgt i32 %4, 0
  %6 = zext i1 %5 to i32
  call void @__VERIFIER_assume(i32 %6)
  %7 = load i32, i32* %3, align 4
  %8 = icmp sgt i32 %7, 0
  %9 = zext i1 %8 to i32
  call void @__VERIFIER_assume(i32 %9)
  %10 = load i32, i32* %2, align 4
  %11 = add nsw i32 %10, 50
  %12 = load i32, i32* %2, align 4
  %13 = load i32, i32* %3, align 4
  %14 = add nsw i32 %12, %13
  %15 = icmp sgt i32 %11, %14
  br i1 %15, label %17, label %16

; <label>:16:                                     ; preds = %0
  call void @__VERIFIER_error()
  br label %17

; <label>:17:                                     ; preds = %16, %0
  %18 = phi i1 [ true, %0 ], [ false, %16 ]
  %19 = zext i1 %18 to i32
  ret i32 0
}

declare void @__VERIFIER_assume(i32) #1

declare void @__VERIFIER_error() #1

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 6.0.0-1ubuntu2 (tags/RELEASE_600/final)"}
