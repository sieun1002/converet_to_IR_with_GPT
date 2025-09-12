; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x1247
; Intent: Initialize an int array, sort it with insertion_sort, print elements and a newline (confidence=0.92). Evidence: call to insertion_sort; loop printing with "%d " and final putchar('\n').
; Preconditions: insertion_sort(i32*, i64) is available and sorts in-place.
; Postconditions: Writes the array elements to stdout followed by a newline; returns 0.

; Only the necessary external declarations:
declare void @insertion_sort(i32*, i64)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

@.str = private unnamed_addr constant [4 x i8] c"%d \00"

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %arr.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9,  i32* %arr.ptr, align 4
  %e1 = getelementptr inbounds i32, i32* %arr.ptr, i64 1
  store i32 1,  i32* %e1, align 4
  %e2 = getelementptr inbounds i32, i32* %arr.ptr, i64 2
  store i32 5,  i32* %e2, align 4
  %e3 = getelementptr inbounds i32, i32* %arr.ptr, i64 3
  store i32 3,  i32* %e3, align 4
  %e4 = getelementptr inbounds i32, i32* %arr.ptr, i64 4
  store i32 7,  i32* %e4, align 4
  %e5 = getelementptr inbounds i32, i32* %arr.ptr, i64 5
  store i32 2,  i32* %e5, align 4
  %e6 = getelementptr inbounds i32, i32* %arr.ptr, i64 6
  store i32 8,  i32* %e6, align 4
  %e7 = getelementptr inbounds i32, i32* %arr.ptr, i64 7
  store i32 6,  i32* %e7, align 4
  %e8 = getelementptr inbounds i32, i32* %arr.ptr, i64 8
  store i32 4,  i32* %e8, align 4
  %e9 = getelementptr inbounds i32, i32* %arr.ptr, i64 9
  store i32 0,  i32* %e9, align 4

  call void @insertion_sort(i32* %arr.ptr, i64 10)

  br label %loop

loop:
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop.body ]
  %cond = icmp ult i64 %i, 10
  br i1 %cond, label %loop.body, label %done

loop.body:
  %elem.ptr = getelementptr inbounds i32, i32* %arr.ptr, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt, i32 %elem)
  %i.next = add i64 %i, 1
  br label %loop

done:
  %putc = call i32 @putchar(i32 10)
  ret i32 0
}