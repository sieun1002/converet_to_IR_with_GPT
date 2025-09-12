; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x144B
; Intent: Print an array, heap-sort it, then print it again (confidence=0.95). Evidence: calls to heap_sort and printf of "%d " in loops.
; Preconditions: None
; Postconditions: Returns 0

@.str.init = private unnamed_addr constant [17 x i8] c"Original array: \00", align 1
@.str.d = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.str.sorted = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1

; Only the needed extern declarations:
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %arr = alloca [9 x i32], align 16
  %0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %0, align 4
  %1 = getelementptr inbounds i32, i32* %0, i64 1
  store i32 3, i32* %1, align 4
  %2 = getelementptr inbounds i32, i32* %0, i64 2
  store i32 9, i32* %2, align 4
  %3 = getelementptr inbounds i32, i32* %0, i64 3
  store i32 1, i32* %3, align 4
  %4 = getelementptr inbounds i32, i32* %0, i64 4
  store i32 4, i32* %4, align 4
  %5 = getelementptr inbounds i32, i32* %0, i64 5
  store i32 8, i32* %5, align 4
  %6 = getelementptr inbounds i32, i32* %0, i64 6
  store i32 2, i32* %6, align 4
  %7 = getelementptr inbounds i32, i32* %0, i64 7
  store i32 6, i32* %7, align 4
  %8 = getelementptr inbounds i32, i32* %0, i64 8
  store i32 5, i32* %8, align 4
  %fmt_init = getelementptr inbounds [17 x i8], [17 x i8]* @.str.init, i64 0, i64 0
  call i32 (i8*, ...)* @printf(i8* %fmt_init)
  br label %loop1.header

loop1.header:                                     ; preds = %loop1.latch, %entry
  %i1 = phi i64 [ 0, %entry ], [ %i1.next, %loop1.latch ]
  %cmp1 = icmp ult i64 %i1, 9
  br i1 %cmp1, label %loop1.body, label %after1

loop1.body:                                       ; preds = %loop1.header
  %elem.ptr1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i1
  %val1 = load i32, i32* %elem.ptr1, align 4
  %fmt_d = getelementptr inbounds [4 x i8], [4 x i8]* @.str.d, i64 0, i64 0
  call i32 (i8*, ...)* @printf(i8* %fmt_d, i32 %val1)
  br label %loop1.latch

loop1.latch:                                      ; preds = %loop1.body
  %i1.next = add nuw nsw i64 %i1, 1
  br label %loop1.header

after1:                                           ; preds = %loop1.header
  call i32 @putchar(i32 10)
  %arr.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  call void @heap_sort(i32* %arr.ptr, i64 9)
  %fmt_sorted = getelementptr inbounds [15 x i8], [15 x i8]* @.str.sorted, i64 0, i64 0
  call i32 (i8*, ...)* @printf(i8* %fmt_sorted)
  br label %loop2.header

loop2.header:                                     ; preds = %loop2.latch, %after1
  %i2 = phi i64 [ 0, %after1 ], [ %i2.next, %loop2.latch ]
  %cmp2 = icmp ult i64 %i2, 9
  br i1 %cmp2, label %loop2.body, label %after2

loop2.body:                                       ; preds = %loop2.header
  %elem.ptr2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i2
  %val2 = load i32, i32* %elem.ptr2, align 4
  %fmt_d2 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.d, i64 0, i64 0
  call i32 (i8*, ...)* @printf(i8* %fmt_d2, i32 %val2)
  br label %loop2.latch

loop2.latch:                                      ; preds = %loop2.body
  %i2.next = add nuw nsw i64 %i2, 1
  br label %loop2.header

after2:                                           ; preds = %loop2.header
  call i32 @putchar(i32 10)
  ret i32 0
}