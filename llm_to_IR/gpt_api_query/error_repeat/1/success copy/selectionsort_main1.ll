; ModuleID = 'main_module'
target triple = "x86_64-pc-linux-gnu"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@.str.sorted = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.d = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare dso_local void @selection_sort(i32* noundef, i32 noundef)
declare dso_local i32 @printf(i8* noundef, ...)

define dso_local i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %i = alloca i32, align 4
  %n = alloca i32, align 4

  store i32 5, i32* %n, align 4

  %arr0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 29, i32* %arr0, align 16
  %arr1 = getelementptr inbounds i32, i32* %arr0, i64 1
  store i32 10, i32* %arr1, align 4
  %arr2 = getelementptr inbounds i32, i32* %arr0, i64 2
  store i32 14, i32* %arr2, align 8
  %arr3 = getelementptr inbounds i32, i32* %arr0, i64 3
  store i32 37, i32* %arr3, align 4
  %arr4 = getelementptr inbounds i32, i32* %arr0, i64 4
  store i32 13, i32* %arr4, align 16

  %n.load = load i32, i32* %n, align 4
  call void @selection_sort(i32* noundef %arr0, i32 noundef %n.load)

  %p.sorted = getelementptr inbounds [15 x i8], [15 x i8]* @.str.sorted, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* noundef %p.sorted)

  store i32 0, i32* %i, align 4
  br label %loop

loop:
  %i.val = load i32, i32* %i, align 4
  %n.cur = load i32, i32* %n, align 4
  %cmp = icmp slt i32 %i.val, %n.cur
  br i1 %cmp, label %body, label %done

body:
  %idx.ext = sext i32 %i.val to i64
  %elem.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 %idx.ext
  %elem = load i32, i32* %elem.ptr, align 4
  %p.d = getelementptr inbounds [4 x i8], [4 x i8]* @.str.d, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* noundef %p.d, i32 noundef %elem)
  %inc = add nsw i32 %i.val, 1
  store i32 %inc, i32* %i, align 4
  br label %loop

done:
  ret i32 0
}