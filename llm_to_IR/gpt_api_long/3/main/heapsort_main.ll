; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x144B
; Intent: Print an int array, heap-sort it, then print again (confidence=0.95). Evidence: call to heap_sort with i32* and length; two printf loops using "%d ".
; Preconditions: heap_sort expects a pointer to i32 elements and a length in elements.
; Postconditions: None.

@.str = private unnamed_addr constant [14 x i8] c"Before sort:\0A\00", align 1
@.str.1 = private unnamed_addr constant [13 x i8] c"After sort:\0A\00", align 1
@.fmt_int = private unnamed_addr constant [4 x i8] c"%d \00", align 1

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
  %fmt0 = getelementptr inbounds [14 x i8], [14 x i8]* @.str, i64 0, i64 0
  %call0 = call i32 (i8*, ...) @printf(i8* %fmt0)
  br label %loop.pre

loop.pre:                                         ; preds = %entry
  br label %loop

loop:                                             ; preds = %loop, %loop.pre
  %i = phi i64 [ 0, %loop.pre ], [ %i.next, %loop ]
  %cmp = icmp ult i64 %i, 9
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:                                        ; preds = %loop
  %elem.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i
  %val = load i32, i32* %elem.ptr, align 4
  %fmtint = getelementptr inbounds [4 x i8], [4 x i8]* @.fmt_int, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmtint, i32 %val)
  %i.next = add nuw nsw i64 %i, 1
  br label %loop

loop.end:                                         ; preds = %loop
  %putc0 = call i32 @putchar(i32 10)
  %arrdecay = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  call void @heap_sort(i32* %arrdecay, i64 9)
  %fmt1 = getelementptr inbounds [13 x i8], [13 x i8]* @.str.1, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt1)
  br label %loop2.pre

loop2.pre:                                        ; preds = %loop.end
  br label %loop2

loop2:                                            ; preds = %loop2, %loop2.pre
  %j = phi i64 [ 0, %loop2.pre ], [ %j.next, %loop2 ]
  %cmp2 = icmp ult i64 %j, 9
  br i1 %cmp2, label %loop2.body, label %loop2.end

loop2.body:                                       ; preds = %loop2
  %elem.ptr2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j
  %val2 = load i32, i32* %elem.ptr2, align 4
  %fmtint2 = getelementptr inbounds [4 x i8], [4 x i8]* @.fmt_int, i64 0, i64 0
  %call3 = call i32 (i8*, ...) @printf(i8* %fmtint2, i32 %val2)
  %j.next = add nuw nsw i64 %j, 1
  br label %loop2

loop2.end:                                        ; preds = %loop2
  %putc1 = call i32 @putchar(i32 10)
  ret i32 0
}