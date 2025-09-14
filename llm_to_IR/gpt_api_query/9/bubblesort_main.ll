; ModuleID = 'binary.ll'
source_filename = "binary.ll"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@__stack_chk_guard = external global i64

declare void @bubble_sort(i32* nocapture, i64)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @__stack_chk_fail() noreturn

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %len = alloca i64, align 8
  %i = alloca i64, align 8
  %canary = alloca i64, align 8
  %guard = load i64, i64* @__stack_chk_guard
  store i64 %guard, i64* %canary, align 8

  %arr0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr0, align 4
  %arr1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %arr1, align 4
  %arr2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %arr2, align 4
  %arr3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %arr3, align 4
  %arr4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %arr4, align 4
  %arr5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %arr5, align 4
  %arr6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %arr6, align 4
  %arr7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr7, align 4
  %arr8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %arr8, align 4
  %arr9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %arr9, align 4

  store i64 10, i64* %len, align 8

  %arrptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %lenv = load i64, i64* %len, align 8
  call void @bubble_sort(i32* %arrptr, i64 %lenv)

  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.body:
  %idx = load i64, i64* %i, align 8
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %idx
  %val = load i32, i32* %elem.ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt, i32 %val)
  %inc = add i64 %idx, 1
  store i64 %inc, i64* %i, align 8
  br label %loop.cond

loop.cond:
  %idx2 = load i64, i64* %i, align 8
  %len2 = load i64, i64* %len, align 8
  %cmp = icmp ult i64 %idx2, %len2
  br i1 %cmp, label %loop.body, label %after.loop

after.loop:
  %newline = call i32 @putchar(i32 10)
  %guard.cur = load i64, i64* @__stack_chk_guard
  %guard.saved = load i64, i64* %canary, align 8
  %ok = icmp eq i64 %guard.cur, %guard.saved
  br i1 %ok, label %ret, label %stackfail

stackfail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}