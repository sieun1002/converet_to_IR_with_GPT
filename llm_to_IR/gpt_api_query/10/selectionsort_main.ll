; ModuleID = 'main_module'
source_filename = "main"
target triple = "x86_64-pc-linux-gnu"

@.str.sorted = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.int = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @selection_sort(i32* noundef, i32 noundef)
declare i32 @printf(i8* noundef, ...)

define i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %i = alloca i32, align 4

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

  %p.sorted = getelementptr inbounds [15 x i8], [15 x i8]* @.str.sorted, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* noundef %p.sorted)

  store i32 0, i32* %i, align 4
  br label %loop

loop:                                             ; preds = %body, %entry
  %iv = load i32, i32* %i, align 4
  %cmp = icmp slt i32 %iv, 5
  br i1 %cmp, label %body, label %done

body:                                             ; preds = %loop
  %idx = sext i32 %iv to i64
  %elem.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 %idx
  %val = load i32, i32* %elem.ptr, align 4
  %p.int = getelementptr inbounds [4 x i8], [4 x i8]* @.str.int, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* noundef %p.int, i32 noundef %val)
  %inc = add nsw i32 %iv, 1
  store i32 %inc, i32* %i, align 4
  br label %loop

done:                                             ; preds = %loop
  ret i32 0
}