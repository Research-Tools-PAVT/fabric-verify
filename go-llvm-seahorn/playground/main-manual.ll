; ModuleID = 'temp.c'
source_filename = "temp.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; Function Attrs: noinline nounwind optnone uwtable 
define void @main() #0 {
entry:
  %a.0 = alloca i32, align 4
  store i32 90, i32* %a.0, align 4
  %a.ld.0 = load i32, i32* %a.0, align 4
  %icmp.0 = icmp sgt i32 %a.ld.0, 0
  %zext.0 = zext i1 %icmp.0 to i32
  call void @__VERIFIER_assume(i32 %zext.0) 
  %a.ld.1 = load i32, i32* %a.0, align 4
  %add.0 = add i32 %a.ld.1, 50
  %a.ld.2 = load i32, i32* %a.0, align 4
  %icmp.1 = icmp sgt i32 %add.0, %a.ld.2
  br i1 %icmp.1, label %block_true, label %block_false

block_false:                                    ; preds = %entry
  call void @__VERIFIER_error()
  br label %block_true

block_true:                                     ; preds = %block_false, %entry
  %phi.0 = phi i1 [ true, %entry ], [ false, %block_false ]
  %phi.1 = zext i1 %phi.0 to i32
  ret void
}

declare void @__VERIFIER_assume(i32) #1

declare void @__VERIFIER_error() #1

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 6.0.0-1ubuntu2 (tags/RELEASE_600/final)"}