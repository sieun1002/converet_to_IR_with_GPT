; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x144B
; Intent: demonstrate heap sort on a fixed array and print before/after (confidence=0.95). Evidence: call to heap_sort with array and length; two printf-loops using "%d " and newline via putchar
; Preconditions: none
; Postconditions: returns 0

@__stack_chk_guard = external local_unnamed_addr global i64
@.str_before = private unnamed_addr constant [9 x i8] c"Before: \00"
@.str_after = private unnamed_addr constant [8 x i8] c"After: \00"
@.str_d = private unnamed_addr constant [4 x i8] c"%d \00"

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)
declare void @__stack_chk_fail() noreturn

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %canary0 = load i64, i64* @__stack_chk_guard
  %arr = alloca [9 x i32], align 16
  %arr0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %arr0, align 4
  %arr1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %arr1, align 4
  %arr2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %arr2, align 4
  %arr3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %arr3, align 4
  %arr4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %arr4, align 4
  %arr5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %arr5, align 4
  %arr6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %arr6, align 4
  %arr7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr7, align 4
  %arr8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %arr8, align 4
  %before_ptr = getelementptr inbounds [9 x i8], [9 x i8]* @.str_before, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %before_ptr)
  br label %loop1.cond

loop1.cond:                                       ; preds = %loop1.body, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop1.body ]
  %cmp = icmp ult i64 %i, 9
  br i1 %cmp, label %loop1.body, label %after_loop1

loop1.body:                                       ; preds = %loop1.cond
  %elem_ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i
  %val = load i32, i32* %elem_ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str_d, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt, i32 %val)
  %i.next = add nuw nsw i64 %i, 1
  br label %loop1.cond

after_loop1:                                       ; preds = %loop1.cond
  call i32 @putchar(i32 10)
  %base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  call void @heap_sort(i32* %base, i64 9)
  %after_ptr = getelementptr inbounds [8 x i8], [8 x i8]* @.str_after, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %after_ptr)
  br label %loop2.cond

loop2.cond:                                       ; preds = %loop2.body, %after_loop1
  %j = phi i64 [ 0, %after_loop1 ], [ %j.next, %loop2.body ]
  %cmp2 = icmp ult i64 %j, 9
  br i1 %cmp2, label %loop2.body, label %after_loop2

loop2.body:                                       ; preds = %loop2.cond
  %ptr2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j
  %val2 = load i32, i32* %ptr2, align 4
  %fmt2 = getelementptr inbounds [4 x i8], [4 x i8]* @.str_d, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt2, i32 %val2)
  %j.next = add nuw nsw i64 %j, 1
  br label %loop2.cond

after_loop2:                                       ; preds = %loop2.cond
  call i32 @putchar(i32 10)
  %canary1 = load i64, i64* @__stack_chk_guard
  %ok = icmp eq i64 %canary0, %canary1
  br i1 %ok, label %ret, label %stackfail

stackfail:                                         ; preds = %after_loop2
  call void @__stack_chk_fail()
  unreachable

ret:                                               ; preds = %after_loop2
  ret i32 0
}