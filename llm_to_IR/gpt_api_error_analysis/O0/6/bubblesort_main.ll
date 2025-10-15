; ModuleID = 'main.ll'
target triple = "x86_64-pc-linux-gnu"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @bubble_sort(i32* noundef, i64 noundef)
declare i32 @printf(i8* noundef, ...)
declare i32 @putchar(i32 noundef)

define i32 @main(i32 %argc, i8** %argv) {
entry:
  %arr = alloca [10 x i32], align 16
  %n = alloca i64, align 8
  %arr0ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr0ptr, align 4
  %arr1ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %arr1ptr, align 4
  %arr2ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %arr2ptr, align 4
  %arr3ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %arr3ptr, align 4
  %arr4ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %arr4ptr, align 4
  %arr5ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %arr5ptr, align 4
  %arr6ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %arr6ptr, align 4
  %arr7ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr7ptr, align 4
  %arr8ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %arr8ptr, align 4
  %arr9ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %arr9ptr, align 4
  store i64 10, i64* %n, align 8
  %arrdecay = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %nval = load i64, i64* %n, align 8
  call void @bubble_sort(i32* %arrdecay, i64 %nval)
  br label %loop

loop:
  %i = phi i64 [ 0, %entry ], [ %i.next, %body ]
  %ncur = load i64, i64* %n, align 8
  %cmp = icmp ult i64 %i, %ncur
  br i1 %cmp, label %body, label %after

body:
  %elem.ptr = getelementptr inbounds i32, i32* %arrdecay, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %callprintf = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %elem)
  %i.next = add i64 %i, 1
  br label %loop

after:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}