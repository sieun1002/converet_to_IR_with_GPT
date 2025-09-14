; ModuleID = 'recovered'
source_filename = "recovered.ll"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @selection_sort(i32*, i32)
declare i32 @printf(i8*, ...)

define i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %n = alloca i32, align 4
  %i = alloca i32, align 4

  ; initialize array: 0x1D, 0x0A, 0x0E, 0x25, 0x0D
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

  store i32 5, i32* %n, align 4

  ; call selection_sort(&arr[0], n)
  %arr_ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %nval = load i32, i32* %n, align 4
  call void @selection_sort(i32* %arr_ptr, i32 %nval)

  ; printf("Sorted array: ")
  %fmt0 = getelementptr inbounds [15 x i8], [15 x i8]* @.str, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt0)

  ; i = 0
  store i32 0, i32* %i, align 4
  br label %loop

loop:
  %iv = load i32, i32* %i, align 4
  %nv = load i32, i32* %n, align 4
  %cmp = icmp slt i32 %iv, %nv
  br i1 %cmp, label %body, label %done

body:
  %idx = sext i32 %iv to i64
  %elem.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 %idx
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt1 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.1, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt1, i32 %elem)
  %inc = add nsw i32 %iv, 1
  store i32 %inc, i32* %i, align 4
  br label %loop

done:
  ret i32 0
}