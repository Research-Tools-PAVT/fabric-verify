; ModuleID = 'harness'
source_filename = "harness"
target datalayout = "e-m:e-p:32:32-f64:32:64-f80:32-n8:16:32-S128"

; Function Attrs: noinline
declare i8* @__emv(i8*) #0

define void @__seahorn_mem_init_routine() {
entry:
  ret void
}

declare void @__seahorn_mem_alloc(i8*, i8*, i64, i64)

declare void @__seahorn_mem_init(i8*, i64, i64)

attributes #0 = { noinline }
