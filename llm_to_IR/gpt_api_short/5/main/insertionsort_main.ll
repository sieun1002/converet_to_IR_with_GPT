; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x1247
; Intent: initialize an array, sort it with insertion_sort, and print the result (confidence=0.86). Evidence: call to insertion_sort with array/length; loop printing values with "%d " then newline.
; Preconditions: None
; Postconditions: Sorted array printed to stdout followed by a newline.

@format = private unnamed_addr constant [4 x i8] c"%d \00", align 1

; Only the necessary external declarations:
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @insertion_sort(i32*, i64)

define dso_local i32 @main() local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  store [10 x i32] [i32 9, i32 1, i32 5, i32 3, i32 7, i32 2, i32 8, i32 6, i32 4, i32 0], [10 x i32]* %arr, align 16
  %arrp = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  call void @insertion_sort(i32* %arrp, i64 10)
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i = phi i64 [ 0, %entry ], [ %inc, %for.inc ]
  %cmp = icmp ult i64 %i, 10
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %elem.ptr = getelementptr inbounds i32, i32* %arrp, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @format, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt, i32 %elem)
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %inc = add i64 %i, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}