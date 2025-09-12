; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x144B
; Intent: Print an array, sort it with heap_sort, then print it again (confidence=0.95). Evidence: call to heap_sort and two printf loops around it.
; Preconditions: heap_sort sorts in-place: void heap_sort(i32* base, i64 n)

@.str = private unnamed_addr constant [9 x i8] c"Before: \00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.str.2 = private unnamed_addr constant [8 x i8] c"After: \00", align 1

; Only the needed extern declarations:
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %arr = alloca [9 x i32], align 16
  %0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %0, align 4
  %1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %1, align 4
  %2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %2, align 4
  %3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %3, align 4
  %4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %4, align 4
  %5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %5, align 4
  %6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %6, align 4
  %7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %7, align 4
  %8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %8, align 4
  %fmt_before = getelementptr inbounds [9 x i8], [9 x i8]* @.str, i64 0, i64 0
  %call_before = call i32 (i8*, ...) @printf(i8* %fmt_before)
  br label %loop1

loop1:                                            ; preds = %entry, %loop1.body
  %i = phi i64 [ 0, %entry ], [ %inc, %loop1.body ]
  %cmp1 = icmp ult i64 %i, 9
  br i1 %cmp1, label %loop1.body, label %afterloop1

loop1.body:                                       ; preds = %loop1
  %elem.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt_d = getelementptr inbounds [4 x i8], [4 x i8]* @.str.1, i64 0, i64 0
  %call_print = call i32 (i8*, ...) @printf(i8* %fmt_d, i32 %elem)
  %inc = add i64 %i, 1
  br label %loop1

afterloop1:                                       ; preds = %loop1
  %nl1 = call i32 @putchar(i32 10)
  %base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  call void @heap_sort(i32* %base, i64 9)
  %fmt_after = getelementptr inbounds [8 x i8], [8 x i8]* @.str.2, i64 0, i64 0
  %call_after = call i32 (i8*, ...) @printf(i8* %fmt_after)
  br label %loop2

loop2:                                            ; preds = %afterloop1, %loop2.body
  %j = phi i64 [ 0, %afterloop1 ], [ %j.inc, %loop2.body ]
  %cmp2 = icmp ult i64 %j, 9
  br i1 %cmp2, label %loop2.body, label %afterloop2

loop2.body:                                       ; preds = %loop2
  %elem2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j
  %elem2 = load i32, i32* %elem2.ptr, align 4
  %fmt_d2 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.1, i64 0, i64 0
  %call_print2 = call i32 (i8*, ...) @printf(i8* %fmt_d2, i32 %elem2)
  %j.inc = add i64 %j, 1
  br label %loop2

afterloop2:                                       ; preds = %loop2
  %nl2 = call i32 @putchar(i32 10)
  ret i32 0
}