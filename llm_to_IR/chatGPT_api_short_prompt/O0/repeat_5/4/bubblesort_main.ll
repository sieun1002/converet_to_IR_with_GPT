; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x128B
; Intent: Initialize an array, sort it with bubble_sort, print elements, then newline (confidence=0.95). Evidence: call bubble_sort with array and length; loop printing with "%d " and final putchar('\n')
; Preconditions: none
; Postconditions: prints sorted numbers followed by a newline; returns 0

@format = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@__stack_chk_guard = external thread_local global i64

; Only the necessary external declarations:
declare void @bubble_sort(i32*, i64)
declare i32 @_printf(i8*, ...)
declare i32 @_putchar(i32)
declare void @___stack_chk_fail()

define dso_local i32 @main() local_unnamed_addr {
entry:
  %saved_canary = alloca i64, align 8
  %arr = alloca [10 x i32], align 16
  %i = alloca i64, align 8
  %0 = load i64, i64* @__stack_chk_guard
  store i64 %0, i64* %saved_canary, align 8
  %1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %1, align 4
  %2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %2, align 4
  %3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %3, align 4
  %4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %4, align 4
  %5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %5, align 4
  %6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %6, align 4
  %7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %7, align 4
  %8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %8, align 4
  %9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %9, align 4
  %10 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %10, align 4
  call void @bubble_sort(i32* %1, i64 10)
  store i64 0, i64* %i, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.body, %entry
  %11 = load i64, i64* %i, align 8
  %cmp = icmp ult i64 %11, 10
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %12 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %11
  %13 = load i32, i32* %12, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @format, i64 0, i64 0
  %call = call i32 (i8*, ...) @_printf(i8* %fmtptr, i32 %13)
  %inc = add i64 %11, 1
  store i64 %inc, i64* %i, align 8
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %call1 = call i32 @_putchar(i32 10)
  %cur = load i64, i64* @__stack_chk_guard
  %saved = load i64, i64* %saved_canary, align 8
  %ok = icmp eq i64 %saved, %cur
  br i1 %ok, label %ret, label %fail

fail:                                             ; preds = %for.end
  call void @___stack_chk_fail()
  unreachable

ret:                                              ; preds = %for.end
  ret i32 0
}