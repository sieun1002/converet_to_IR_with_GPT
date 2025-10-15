; ModuleID = 'main.ll'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str.sorted = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.int = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @selection_sort(i32* noundef, i32 noundef)
declare i32 @printf(i8* noundef, ...)

define i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %arr0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 29, i32* %arr0, align 4
  %arr1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 10, i32* %arr1, align 4
  %arr2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 14, i32* %arr2, align 4
  %arr3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 37, i32* %arr3, align 4
  %arr4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 13, i32* %arr4, align 4
  %arrdecay = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  call void @selection_sort(i32* noundef %arrdecay, i32 noundef 5)
  %fmt_sorted_ptr = getelementptr inbounds [15 x i8], [15 x i8]* @.str.sorted, i64 0, i64 0
  %call0 = call i32 (i8*, ...) @printf(i8* noundef %fmt_sorted_ptr)
  br label %for.cond

for.cond:
  %i = phi i32 [ 0, %entry ], [ %inc, %for.inc ]
  %cmp = icmp slt i32 %i, 5
  br i1 %cmp, label %for.body, label %for.end

for.body:
  %idx.ext = sext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arrdecay, i64 %idx.ext
  %val = load i32, i32* %elem.ptr, align 4
  %fmt_d_ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str.int, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* noundef %fmt_d_ptr, i32 noundef %val)
  br label %for.inc

for.inc:
  %inc = add nsw i32 %i, 1
  br label %for.cond

for.end:
  ret i32 0
}