; ModuleID: fixed_module
source_filename = "fixed_module"
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"

@.str.sorted = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.fmt = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare dso_local i32 @printf(i8*, ...)

declare dso_local void @selection_sort(i32*, i32)

define dso_local void @__main() {
entry:
  ret void
}

define dso_local i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %n = alloca i32, align 4
  %i = alloca i32, align 4
  call void @__main()
  %arr0ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 29, i32* %arr0ptr, align 4
  %arr1ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 10, i32* %arr1ptr, align 4
  %arr2ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 14, i32* %arr2ptr, align 4
  %arr3ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 37, i32* %arr3ptr, align 4
  %arr4ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 13, i32* %arr4ptr, align 4
  store i32 5, i32* %n, align 4
  %arrdecay = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %nval = load i32, i32* %n, align 4
  call void @selection_sort(i32* %arrdecay, i32 %nval)
  %fmt1 = getelementptr inbounds [15 x i8], [15 x i8]* @.str.sorted, i64 0, i64 0
  %callp1 = call i32 (i8*, ...) @printf(i8* %fmt1)
  store i32 0, i32* %i, align 4
  br label %loop

loop:
  %i_curr = load i32, i32* %i, align 4
  %n_curr = load i32, i32* %n, align 4
  %cmp = icmp slt i32 %i_curr, %n_curr
  br i1 %cmp, label %body, label %after

body:
  %i64 = sext i32 %i_curr to i64
  %aptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 %i64
  %aval = load i32, i32* %aptr, align 4
  %fmt2 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.fmt, i64 0, i64 0
  %callp2 = call i32 (i8*, ...) @printf(i8* %fmt2, i32 %aval)
  %inc = add nsw i32 %i_curr, 1
  store i32 %inc, i32* %i, align 4
  br label %loop

after:
  ret i32 0
}