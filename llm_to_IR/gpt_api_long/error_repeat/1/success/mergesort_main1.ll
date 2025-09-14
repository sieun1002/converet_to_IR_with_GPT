; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x13F7
; Intent: sort a fixed integer array using merge_sort and print the result (confidence=0.92). Evidence: call to merge_sort with int* and length; loop printing with "%d ".
; Preconditions: merge_sort expects (i32* base, i64 n) and does not require additional context.
; Postconditions: prints the (presumably sorted) array elements followed by a newline; returns 0.

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

; Only the needed extern declarations:
declare void @merge_sort(i32*, i64)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %idx1 = getelementptr inbounds i32, i32* %0, i64 1
  %idx2 = getelementptr inbounds i32, i32* %0, i64 2
  %idx3 = getelementptr inbounds i32, i32* %0, i64 3
  %idx4 = getelementptr inbounds i32, i32* %0, i64 4
  %idx5 = getelementptr inbounds i32, i32* %0, i64 5
  %idx6 = getelementptr inbounds i32, i32* %0, i64 6
  %idx7 = getelementptr inbounds i32, i32* %0, i64 7
  %idx8 = getelementptr inbounds i32, i32* %0, i64 8
  %idx9 = getelementptr inbounds i32, i32* %0, i64 9
  store i32 9, i32* %0, align 4
  store i32 1, i32* %idx1, align 4
  store i32 5, i32* %idx2, align 4
  store i32 3, i32* %idx3, align 4
  store i32 7, i32* %idx4, align 4
  store i32 2, i32* %idx5, align 4
  store i32 8, i32* %idx6, align 4
  store i32 6, i32* %idx7, align 4
  store i32 4, i32* %idx8, align 4
  store i32 0, i32* %idx9, align 4
  call void @merge_sort(i32* %0, i64 10)
  br label %loop.cond

loop.cond:
  %i = phi i64 [ 0, %entry ], [ %inc, %loop.body ]
  %cmp = icmp ult i64 %i, 10
  br i1 %cmp, label %loop.body, label %after

loop.body:
  %elem.ptr = getelementptr inbounds i32, i32* %0, i64 %i
  %val = load i32, i32* %elem.ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt, i32 %val)
  %inc = add nuw nsw i64 %i, 1
  br label %loop.cond

after:
  %pc = call i32 @putchar(i32 10)
  ret i32 0
}