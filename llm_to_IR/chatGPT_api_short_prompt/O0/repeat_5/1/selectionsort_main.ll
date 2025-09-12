; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x124D
; Intent: sort and print a 5-element int array using selection_sort (confidence=0.89). Evidence: call to selection_sort; prints "Sorted array: " and elements with "%d ".
; Preconditions: selection_sort must be provided.
; Postconditions: writes sorted numbers to stdout and returns 0.

; Only the necessary external declarations:
declare dso_local i32 @printf(i8*, ...) local_unnamed_addr
declare dso_local void @selection_sort(i32*, i32) local_unnamed_addr

@format = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@aD = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %arr = alloca [5 x i32], align 16
  %0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 29, i32* %0, align 4
  %1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 10, i32* %1, align 4
  %2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 14, i32* %2, align 4
  %3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 37, i32* %3, align 4
  %4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 13, i32* %4, align 4
  call void @selection_sort(i32* %0, i32 5)
  %fmt = getelementptr inbounds [15 x i8], [15 x i8]* @format, i64 0, i64 0
  %callfmt = call i32 @printf(i8* %fmt)
  br label %for

for:
  %i = phi i32 [ 0, %entry ], [ %inc, %body ]
  %cmp = icmp slt i32 %i, 5
  br i1 %cmp, label %body, label %ret

body:
  %idxext = sext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %0, i64 %idxext
  %val = load i32, i32* %elem.ptr, align 4
  %fmt2 = getelementptr inbounds [4 x i8], [4 x i8]* @aD, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt2, i32 %val)
  %inc = add nsw i32 %i, 1
  br label %for

ret:
  ret i32 0
}