; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x128B
; Intent: Initialize fixed array, sort it via bubble_sort, then print elements and a newline (confidence=0.92). Evidence: call to bubble_sort with int array and count; printf loop with "%d ".
; Preconditions: None
; Postconditions: Returns 0 after printing the sorted array followed by a newline

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@__stack_chk_guard = external global i64

declare void @bubble_sort(i32*, i64)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @__stack_chk_fail()

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %canary = alloca i64, align 8
  %guard = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard, i64* %canary, align 8
  %0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %0, align 4
  %1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %1, align 4
  %2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %2, align 4
  %3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %3, align 4
  %4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %4, align 4
  %5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %5, align 4
  %6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %6, align 4
  %7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %7, align 4
  %8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %8, align 4
  %9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %9, align 4
  %a0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  call void @bubble_sort(i32* %a0, i64 10)
  br label %loop

loop:                                             ; preds = %body, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %body ]
  %cmp = icmp ult i64 %i, 10
  br i1 %cmp, label %body, label %after

body:                                             ; preds = %loop
  %elem.ptr = getelementptr inbounds i32, i32* %a0, i64 %i
  %val = load i32, i32* %elem.ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt, i32 %val)
  %i.next = add i64 %i, 1
  br label %loop

after:                                            ; preds = %loop
  %put = call i32 @putchar(i32 10)
  %saved = load i64, i64* %canary, align 8
  %now = load i64, i64* @__stack_chk_guard, align 8
  %ok = icmp eq i64 %saved, %now
  br i1 %ok, label %ret, label %fail

fail:                                             ; preds = %after
  call void @__stack_chk_fail()
  unreachable

ret:                                              ; preds = %after
  ret i32 0
}