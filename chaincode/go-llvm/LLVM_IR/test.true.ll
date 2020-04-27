; ModuleID = 'testcodes/test.true.bc'
target datalayout = "e-m:e-p:32:32-f64:32:64-f80:32-n8:16:32-S128"
target triple = "i386-unknown-linux-gnu"

@llvm.used = appending global [4 x i8*] [i8* bitcast (void ()* @seahorn.fail to i8*), i8* bitcast (void (i1)* @verifier.assume to i8*), i8* bitcast (void (i1)* @verifier.assume.not to i8*), i8* bitcast (void ()* @verifier.error to i8*)], section "llvm.metadata"

declare i32 @nd() #0

declare void @verifier.assume(i1)

declare void @verifier.assume.not(i1)

declare void @seahorn.fail()

; Function Attrs: noreturn
declare void @verifier.error() #1

declare void @seahorn.fn.enter()

; Function Attrs: nounwind
define i32 @main() #2 {
entry:
  tail call void @seahorn.fn.enter() #3
  %0 = tail call i32 @nd() #3
  %1 = icmp sgt i32 %0, 0
  tail call void @verifier.assume(i1 %1) #3
  %2 = tail call i32 @nd() #3
  %3 = icmp sgt i32 %2, %0
  tail call void @verifier.assume(i1 %3) #3
  br i1 %1, label %.lr.ph.preheader, label %verifier.error

.lr.ph.preheader:                                 ; preds = %entry
  br label %.lr.ph

.lr.ph:                                           ; preds = %.lr.ph.preheader, %.lr.ph
  %j.0.i2 = phi i32 [ %4, %.lr.ph ], [ 0, %.lr.ph.preheader ]
  %k.0.i1 = phi i32 [ %5, %.lr.ph ], [ %2, %.lr.ph.preheader ]
  %4 = add nsw i32 %j.0.i2, 1
  %5 = add nsw i32 %k.0.i1, -1
  %6 = icmp slt i32 %4, %0
  br i1 %6, label %.lr.ph, label %verifier.error.loopexit, !llvm.loop !1

verifier.error.loopexit:                          ; preds = %.lr.ph
  %.lcssa = phi i32 [ %5, %.lr.ph ]
  br label %verifier.error

verifier.error:                                   ; preds = %verifier.error.loopexit, %entry
  %k.0.i.lcssa = phi i32 [ %2, %entry ], [ %.lcssa, %verifier.error.loopexit ]
  %7 = icmp sgt i32 %k.0.i.lcssa, -1
  tail call void @verifier.assume.not(i1 %7) #3
  tail call void @seahorn.fail() #3
  ret i32 42
}

attributes #0 = { "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+fxsr,+mmx,+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { noreturn }
attributes #2 = { nounwind "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+fxsr,+mmx,+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind }

!llvm.ident = !{!0}

!0 = !{!"clang version 3.8.0 (tags/RELEASE_380/final)"}
!1 = distinct !{!1, !2}
!2 = !{!"llvm.loop.unroll.disable"}
