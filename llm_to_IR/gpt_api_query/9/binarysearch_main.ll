; ModuleID = 'bin_to_ir'
source_filename = "bin_to_ir"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.str.1 = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1
@__stack_chk_guard = external global i64

declare i32 @printf(i8*, ...)
declare i64 @binary_search(i32*, i64, i32)
declare void @__stack_chk_fail() noreturn

define i32 @main() {
entry:
  %canary = alloca i64, align 8
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  %n = alloca i64, align 8
  %m = alloca i64, align 8
  %i = alloca i64, align 8
  %idx = alloca i64, align 8

  %guard = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard, i64* %canary, align 8

  store [9 x i32] [i32 -5, i32 -1, i32 0, i32 2, i32 2, i32 3, i32 7, i32 9, i32 12], [9 x i32]* %arr, align 16
  store [3 x i32] [i32 2, i32 5, i32 -5], [3 x i32]* %keys, align 16
  store i64 9, i64* %n, align 8
  store i64 3, i64* %m, align 8
  store i64 0, i64* %i, align 8

  br label %loop.cond

loop.cond:                                        ; preds = %inc, %entry
  %i.val = load i64, i64* %i, align 8
  %m.val = load i64, i64* %m, align 8
  %cmp = icmp ult i64 %i.val, %m.val
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:                                        ; preds = %loop.cond
  %keyptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %i.val
  %key = load i32, i32* %keyptr, align 4
  %nval = load i64, i64* %n, align 8
  %arrptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %res = call i64 @binary_search(i32* %arrptr, i64 %nval, i32 %key)
  store i64 %res, i64* %idx, align 8
  %isneg = icmp slt i64 %res, 0
  br i1 %isneg, label %notfound, label %found

found:                                            ; preds = %loop.body
  %fmt = getelementptr inbounds ([21 x i8], [21 x i8]* @.str, i64 0, i64 0)
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt, i32 %key, i64 %res)
  br label %inc

notfound:                                         ; preds = %loop.body
  %fmt2 = getelementptr inbounds ([21 x i8], [21 x i8]* @.str.1, i64 0, i64 0)
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt2, i32 %key)
  br label %inc

inc:                                              ; preds = %notfound, %found
  %incval = add i64 %i.val, 1
  store i64 %incval, i64* %i, align 8
  br label %loop.cond

loop.end:                                         ; preds = %loop.cond
  %old_can = load i64, i64* %canary, align 8
  %guard2 = load i64, i64* @__stack_chk_guard, align 8
  %ok = icmp eq i64 %old_can, %guard2
  br i1 %ok, label %ret, label %fail

fail:                                             ; preds = %loop.end
  call void @__stack_chk_fail()
  unreachable

ret:                                              ; preds = %loop.end
  ret i32 0
}