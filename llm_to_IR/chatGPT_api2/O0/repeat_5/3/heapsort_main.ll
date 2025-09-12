; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x144B
; Intent: Print an integer array before and after calling heap_sort (confidence=0.92). Evidence: Calls heap_sort on local int array; prints elements with "%d ".
; Preconditions: heap_sort sorts an array of i32 elements in-place given pointer and length (i64).
; Postconditions: Returns 0. Prints two lines: numbers before and after sorting.

@__stack_chk_guard = external global i64
@format = external global i8
@byte_2011 = external global i8
@.str.d = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)
declare void @__stack_chk_fail()

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %guard = load i64, i64* @__stack_chk_guard
  %arr = alloca [9 x i32], align 16
  %p0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %p0, align 4
  %p1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %p1, align 4
  %p2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %p2, align 4
  %p3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %p3, align 4
  %p4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %p4, align 4
  %p5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %p5, align 4
  %p6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %p6, align 4
  %p7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %p8, align 4
  %n = add i64 0, 9
  %fmt0 = call i32 (i8*, ...) @printf(i8* @format)
  br label %loop1.cond

loop1.cond:
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop1.body.end ]
  %cmp = icmp ult i64 %i, %n
  br i1 %cmp, label %loop1.body, label %after.loop1

loop1.body:
  %elem.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i
  %val = load i32, i32* %elem.ptr, align 4
  %strd = getelementptr inbounds [4 x i8], [4 x i8]* @.str.d, i64 0, i64 0
  %call.printf1 = call i32 (i8*, ...) @printf(i8* %strd, i32 %val)
  br label %loop1.body.end

loop1.body.end:
  %i.next = add i64 %i, 1
  br label %loop1.cond

after.loop1:
  %nl1 = call i32 @putchar(i32 10)
  %base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  call void @heap_sort(i32* %base, i64 %n)
  %fmt1 = call i32 (i8*, ...) @printf(i8* @byte_2011)
  br label %loop2.cond

loop2.cond:
  %j = phi i64 [ 0, %after.loop1 ], [ %j.next, %loop2.body.end ]
  %cmp2 = icmp ult i64 %j, %n
  br i1 %cmp2, label %loop2.body, label %after.loop2

loop2.body:
  %elem.ptr2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j
  %val2 = load i32, i32* %elem.ptr2, align 4
  %strd2 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.d, i64 0, i64 0
  %call.printf2 = call i32 (i8*, ...) @printf(i8* %strd2, i32 %val2)
  br label %loop2.body.end

loop2.body.end:
  %j.next = add i64 %j, 1
  br label %loop2.cond

after.loop2:
  %nl2 = call i32 @putchar(i32 10)
  %guard2 = load i64, i64* @__stack_chk_guard
  %ok = icmp eq i64 %guard, %guard2
  br i1 %ok, label %ret, label %stackfail

stackfail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}