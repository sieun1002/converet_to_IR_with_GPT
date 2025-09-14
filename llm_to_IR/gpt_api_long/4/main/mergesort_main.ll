; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x13F7
; Intent: Sort a fixed array via merge_sort and print the result (confidence=0.92). Evidence: call to merge_sort with buffer+length; loop prints elements with "%d "
; Preconditions: merge_sort expects a buffer of i32 and a length in i64; sorts in-place.

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

; Only the needed extern declarations:
declare void @merge_sort(i32*, i64)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %0, align 4
  %1 = getelementptr inbounds i32, i32* %0, i64 1
  store i32 1, i32* %1, align 4
  %2 = getelementptr inbounds i32, i32* %0, i64 2
  store i32 5, i32* %2, align 4
  %3 = getelementptr inbounds i32, i32* %0, i64 3
  store i32 3, i32* %3, align 4
  %4 = getelementptr inbounds i32, i32* %0, i64 4
  store i32 7, i32* %4, align 4
  %5 = getelementptr inbounds i32, i32* %0, i64 5
  store i32 2, i32* %5, align 4
  %6 = getelementptr inbounds i32, i32* %0, i64 6
  store i32 8, i32* %6, align 4
  %7 = getelementptr inbounds i32, i32* %0, i64 7
  store i32 6, i32* %7, align 4
  %8 = getelementptr inbounds i32, i32* %0, i64 8
  store i32 4, i32* %8, align 4
  %9 = getelementptr inbounds i32, i32* %0, i64 9
  store i32 0, i32* %9, align 4
  call void @merge_sort(i32* %0, i64 10)
  br label %loop

loop:                                             ; preds = %entry, %loop
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop ]
  %cond = icmp ult i64 %i, 10
  br i1 %cond, label %body, label %after

body:                                             ; preds = %loop
  %elt.ptr = getelementptr inbounds i32, i32* %0, i64 %i
  %elt = load i32, i32* %elt.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %_ = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %elt)
  %i.next = add i64 %i, 1
  br label %loop

after:                                            ; preds = %loop
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}