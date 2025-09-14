; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x144B
; Intent: Print an int array before and after calling heap_sort on it (confidence=0.95). Evidence: initialization of 9 ints, two print loops, call to heap_sort(a, len)

@.str0 = private unnamed_addr constant [17 x i8] c"Original array:\0A\00", align 1
@.str1 = private unnamed_addr constant [15 x i8] c"Sorted array:\0A\00", align 1
@.fmt = private unnamed_addr constant [4 x i8] c"%d \00", align 1

; Only the needed extern declarations:
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
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

  %orig = getelementptr inbounds [17 x i8], [17 x i8]* @.str0, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %orig)

  br label %loop1.header

loop1.header:
  %i1 = phi i64 [ 0, %entry ], [ %i1.next, %loop1.body ]
  %cmp1 = icmp ult i64 %i1, 9
  br i1 %cmp1, label %loop1.body, label %after1

loop1.body:
  %elem.ptr1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i1
  %val1 = load i32, i32* %elem.ptr1, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.fmt, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %val1)
  %i1.next = add i64 %i1, 1
  br label %loop1.header

after1:
  call i32 @putchar(i32 10)

  %arr.start = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  call void @heap_sort(i32* %arr.start, i64 9)

  %sorted = getelementptr inbounds [15 x i8], [15 x i8]* @.str1, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %sorted)

  br label %loop2.header

loop2.header:
  %i2 = phi i64 [ 0, %after1 ], [ %i2.next, %loop2.body ]
  %cmp2 = icmp ult i64 %i2, 9
  br i1 %cmp2, label %loop2.body, label %after2

loop2.body:
  %elem.ptr2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i2
  %val2 = load i32, i32* %elem.ptr2, align 4
  %fmtptr2 = getelementptr inbounds [4 x i8], [4 x i8]* @.fmt, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmtptr2, i32 %val2)
  %i2.next = add i64 %i2, 1
  br label %loop2.header

after2:
  call i32 @putchar(i32 10)
  ret i32 0
}