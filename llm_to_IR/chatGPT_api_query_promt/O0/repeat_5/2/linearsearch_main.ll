; ModuleID = 'recovered'
target triple = "x86_64-pc-linux-gnu"

@.str_found = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1
@.str_not_found = private unnamed_addr constant [19 x i8] c"Element not found\00", align 1

@__stack_chk_guard = external global i64

declare i32 @linear_search(i32*, i32, i32)
declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)
declare void @__stack_chk_fail() noreturn

define i32 @main() {
entry:
  %canary.slot = alloca i64, align 8
  %arr = alloca [5 x i32], align 16
  %idx = alloca i32, align 4

  %guard0 = load i64, i64* @__stack_chk_guard
  store i64 %guard0, i64* %canary.slot, align 8

  %arr0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 5, i32* %arr0, align 16
  %arr1 = getelementptr inbounds i32, i32* %arr0, i64 1
  store i32 3, i32* %arr1, align 4
  %arr2 = getelementptr inbounds i32, i32* %arr0, i64 2
  store i32 8, i32* %arr2, align 8
  %arr3 = getelementptr inbounds i32, i32* %arr0, i64 3
  store i32 4, i32* %arr3, align 4
  %arr4 = getelementptr inbounds i32, i32* %arr0, i64 4
  store i32 2, i32* %arr4, align 16

  %call = call i32 @linear_search(i32* %arr0, i32 5, i32 4)
  store i32 %call, i32* %idx, align 4
  %cmp = icmp eq i32 %call, -1
  br i1 %cmp, label %notfound, label %found

found:                                            ; preds = %entry
  %val = load i32, i32* %idx, align 4
  %fmtptr = getelementptr inbounds [27 x i8], [27 x i8]* @.str_found, i64 0, i64 0
  %p = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %val)
  br label %after

notfound:                                         ; preds = %entry
  %nfptr = getelementptr inbounds [19 x i8], [19 x i8]* @.str_not_found, i64 0, i64 0
  %q = call i32 @puts(i8* %nfptr)
  br label %after

after:                                            ; preds = %notfound, %found
  %guard1 = load i64, i64* @__stack_chk_guard
  %saved = load i64, i64* %canary.slot, align 8
  %ok = icmp eq i64 %saved, %guard1
  br i1 %ok, label %ret, label %stackfail

stackfail:                                        ; preds = %after
  call void @__stack_chk_fail()
  unreachable

ret:                                              ; preds = %after
  ret i32 0
}