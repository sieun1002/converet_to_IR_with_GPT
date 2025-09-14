; ModuleID = 'binary_to_ir'
source_filename = "binary_to_ir"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str.sorted = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.fmt = private unnamed_addr constant [4 x i8] c"%d \00", align 1

@__stack_chk_guard = external thread_local global i64

declare i32 @printf(i8*, ...)
declare void @selection_sort(i32*, i32)
declare void @__stack_chk_fail() noreturn

define i32 @main() {
entry:
  %stack_guard = alloca i64, align 8
  %arr = alloca [5 x i32], align 16
  %n = alloca i32, align 4
  %i = alloca i32, align 4

  ; load and store stack canary
  %guard_val = load i64, i64* @__stack_chk_guard
  store i64 %guard_val, i64* %stack_guard, align 8

  ; initialize array: {29, 10, 14, 37, 13}
  %arr0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 29, i32* %arr0, align 4
  %arr1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 10, i32* %arr1, align 4
  %arr2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 14, i32* %arr2, align 4
  %arr3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 37, i32* %arr3, align 4
  %arr4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 13, i32* %arr4, align 4

  ; n = 5
  store i32 5, i32* %n, align 4

  ; call selection_sort(&arr[0], n)
  %arrptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %nval_for_call = load i32, i32* %n, align 4
  call void @selection_sort(i32* %arrptr, i32 %nval_for_call)

  ; printf("Sorted array: ")
  %fmt_sorted = getelementptr inbounds [15 x i8], [15 x i8]* @.str.sorted, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt_sorted)

  ; i = 0
  store i32 0, i32* %i, align 4
  br label %loop

loop:
  %i.cur = load i32, i32* %i, align 4
  %n.cur = load i32, i32* %n, align 4
  %cmp = icmp slt i32 %i.cur, %n.cur
  br i1 %cmp, label %body, label %after

body:
  %idx64 = sext i32 %i.cur to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arrptr, i64 %idx64
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt_num = getelementptr inbounds [4 x i8], [4 x i8]* @.str.fmt, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt_num, i32 %elem)
  %inc = add nsw i32 %i.cur, 1
  store i32 %inc, i32* %i, align 4
  br label %loop

after:
  ; epilogue stack canary check
  %guard_saved = load i64, i64* %stack_guard, align 8
  %guard_now = load i64, i64* @__stack_chk_guard
  %guard_ok = icmp eq i64 %guard_saved, %guard_now
  br i1 %guard_ok, label %ret, label %fail

fail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}