; ModuleID = 'binary.ll'
source_filename = "binary.ll"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @selection_sort(i32* noundef, i32 noundef)
declare i32 @printf(i8* noundef, ...)

define dso_local i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %i = alloca i32, align 4

  %arr.decay = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 29, i32* %arr.decay, align 16
  %idx1 = getelementptr inbounds i32, i32* %arr.decay, i64 1
  store i32 10, i32* %idx1, align 4
  %idx2 = getelementptr inbounds i32, i32* %arr.decay, i64 2
  store i32 14, i32* %idx2, align 8
  %idx3 = getelementptr inbounds i32, i32* %arr.decay, i64 3
  store i32 37, i32* %idx3, align 4
  %idx4 = getelementptr inbounds i32, i32* %arr.decay, i64 4
  store i32 13, i32* %idx4, align 16

  call void @selection_sort(i32* noundef %arr.decay, i32 noundef 5)

  %fmt0 = getelementptr inbounds [15 x i8], [15 x i8]* @.str, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* noundef %fmt0)

  store i32 0, i32* %i, align 4
  br label %loop

loop:
  %iv = load i32, i32* %i, align 4
  %cmp = icmp slt i32 %iv, 5
  br i1 %cmp, label %body, label %end

body:
  %idxext = sext i32 %iv to i64
  %eltp = getelementptr inbounds i32, i32* %arr.decay, i64 %idxext
  %val = load i32, i32* %eltp, align 4
  %fmt1 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.1, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* noundef %fmt1, i32 noundef %val)
  %inc = add nsw i32 %iv, 1
  store i32 %inc, i32* %i, align 4
  br label %loop

end:
  ret i32 0
}