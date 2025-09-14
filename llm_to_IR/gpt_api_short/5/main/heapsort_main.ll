; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x0000144B
; Intent: Demonstrate heap sort on a fixed array and print before/after (confidence=0.86). Evidence: initializes 9-int array; calls heap_sort(arr,n); prints with "%d " loops before and after.
; Preconditions: None
; Postconditions: Prints arrays and returns 0

; Only the necessary external declarations:
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)
declare void @__stack_chk_fail()
@__stack_chk_guard = external thread_local global i64

@format = private unnamed_addr constant [17 x i8] c"Original array:\0A\00"
@aD = private unnamed_addr constant [4 x i8] c"%d \00"
@byte_2011 = private unnamed_addr constant [15 x i8] c"Sorted array:\0A\00"

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %arr = alloca [9 x i32], align 16
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %cookie = alloca i64, align 8
  %guard.load = load i64, i64* @__stack_chk_guard
  store i64 %guard.load, i64* %cookie, align 8
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
  %fmt0 = getelementptr inbounds [17 x i8], [17 x i8]* @format, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt0)
  store i64 0, i64* %i, align 8
  br label %loop1.cond

loop1.cond:
  %i.val = load i64, i64* %i, align 8
  %cmp = icmp ult i64 %i.val, 9
  br i1 %cmp, label %loop1.body, label %loop1.end

loop1.body:
  %elem.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i.val
  %elem = load i32, i32* %elem.ptr, align 4
  %fmtd = getelementptr inbounds [4 x i8], [4 x i8]* @aD, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmtd, i32 %elem)
  %inc = add i64 %i.val, 1
  store i64 %inc, i64* %i, align 8
  br label %loop1.cond

loop1.end:
  call i32 @putchar(i32 10)
  %arr.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  call void @heap_sort(i32* %arr.ptr, i64 9)
  %fmt1 = getelementptr inbounds [15 x i8], [15 x i8]* @byte_2011, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt1)
  store i64 0, i64* %j, align 8
  br label %loop2.cond

loop2.cond:
  %j.val = load i64, i64* %j, align 8
  %cmp2 = icmp ult i64 %j.val, 9
  br i1 %cmp2, label %loop2.body, label %loop2.end

loop2.body:
  %elem2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j.val
  %elem2 = load i32, i32* %elem2.ptr, align 4
  %fmtd2 = getelementptr inbounds [4 x i8], [4 x i8]* @aD, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmtd2, i32 %elem2)
  %inc2 = add i64 %j.val, 1
  store i64 %inc2, i64* %j, align 8
  br label %loop2.cond

loop2.end:
  call i32 @putchar(i32 10)
  %guard.load.end = load i64, i64* @__stack_chk_guard
  %saved.cookie = load i64, i64* %cookie, align 8
  %okcmp = icmp eq i64 %saved.cookie, %guard.load.end
  br i1 %okcmp, label %ok, label %fail

fail:
  call void @__stack_chk_fail()
  br label %ok

ok:
  ret i32 0
}