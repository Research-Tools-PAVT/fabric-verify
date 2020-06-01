; ModuleID = 'test.c'
source_filename = "test.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: noinline nounwind optnone uwtable
define i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  store i32 90, i32* %2, align 4
  %3 = load i32, i32* %2, align 4
  %4 = icmp sgt i32 %3, 0
  %5 = zext i1 %4 to i32
  call void @__VERIFIER_assume(i32 %5)
  %6 = load i32, i32* %2, align 4
  %7 = add nsw i32 %6, 50
  %8 = load i32, i32* %2, align 4
  %9 = icmp sgt i32 %7, %8
  br i1 %9, label %11, label %10

; <label>:10:                                     ; preds = %0
  call void @__VERIFIER_error()
  br label %11

; <label>:11:                                     ; preds = %10, %0
  %12 = phi i1 [ true, %0 ], [ false, %10 ]
  %13 = zext i1 %12 to i32
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
