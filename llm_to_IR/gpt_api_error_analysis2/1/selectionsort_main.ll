; ModuleID = 'main_module'
source_filename = "main.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@__stack_chk_guard = external global i64, align 8

declare void @selection_sort(i32*, i32)
declare i32 @printf(i8*, ...)
declare void @__stack_chk_fail()

define i32 @main() {
entry:
  %canary = alloca i64, align 8
  %arr = alloca [5 x i32], align 16
  %i = alloca i32, align 4
  %n = alloca i32, align 4
  %guard_load = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard_load, i64* %canary, align 8

  %gep0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 29, i32* %gep0, align 4
  %gep1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 10, i32* %gep1, align 4
  %gep2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 14, i32* %gep2, align 4
  %gep3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 37, i32* %gep3, align 4
  %gep4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 13, i32* %gep4, align 4

  store i32 5, i32* %n, align 4

  %arrdecay = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %nval = load i32, i32* %n, align 4
  call void @selection_sort(i32* %arrdecay, i32 %nval)

  %fmt = getelementptr inbounds [15 x i8], [15 x i8]* @.str, i64 0, i64 0
  %call_header = call i32 (i8*, ...) @printf(i8* %fmt)
  store i32 0, i32* %i, align 4
  br label %loop.cond

loop.body:
  %i.val = load i32, i32* %i, align 4
  %idx.ext = sext i32 %i.val to i64
  %elem.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 %idx.ext
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt2 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.1, i64 0, i64 0
  %call_print = call i32 (i8*, ...) @printf(i8* %fmt2, i32 %elem)
  %i.next = add nsw i32 %i.val, 1
  store i32 %i.next, i32* %i, align 4
  br label %loop.cond

loop.cond:
  %i.cur = load i32, i32* %i, align 4
  %n.cur = load i32, i32* %n, align 4
  %cmp = icmp slt i32 %i.cur, %n.cur
  br i1 %cmp, label %loop.body, label %stackcheck

stackcheck:
  %guard_end = load i64, i64* @__stack_chk_guard, align 8
  %canary_load = load i64, i64* %canary, align 8
  %ok = icmp eq i64 %canary_load, %guard_end
  br i1 %ok, label %ret, label %fail

fail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}