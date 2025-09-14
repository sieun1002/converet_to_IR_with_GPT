; ModuleID = 'main'
target triple = "x86_64-pc-linux-gnu"

@.str_init = private unnamed_addr constant [17 x i8] c"Original array: \00", align 1
@.str_num = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.str_sorted = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)

define i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %n = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  store i64 9, i64* %n, align 8
  %arr0ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %arr0ptr, align 4
  %arr1ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %arr1ptr, align 4
  %arr2ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %arr2ptr, align 4
  %arr3ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %arr3ptr, align 4
  %arr4ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %arr4ptr, align 4
  %arr5ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %arr5ptr, align 4
  %arr6ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %arr6ptr, align 4
  %arr7ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr7ptr, align 4
  %arr8ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %arr8ptr, align 4
  %fmt0 = getelementptr inbounds [17 x i8], [17 x i8]* @.str_init, i64 0, i64 0
  %call0 = call i32 (i8*, ...) @printf(i8* %fmt0)
  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %i_val = load i64, i64* %i, align 8
  %n_val = load i64, i64* %n, align 8
  %cmp = icmp ult i64 %i_val, %n_val
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:
  %idxptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i_val
  %val = load i32, i32* %idxptr, align 4
  %fmt_num = getelementptr inbounds [4 x i8], [4 x i8]* @.str_num, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt_num, i32 %val)
  %i_next = add i64 %i_val, 1
  store i64 %i_next, i64* %i, align 8
  br label %loop

loop.end:
  %nlres = call i32 @putchar(i32 10)
  %arrptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %n_load = load i64, i64* %n, align 8
  call void @heap_sort(i32* %arrptr, i64 %n_load)
  %fmt1 = getelementptr inbounds [15 x i8], [15 x i8]* @.str_sorted, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt1)
  store i64 0, i64* %j, align 8
  br label %loop2

loop2:
  %j_val = load i64, i64* %j, align 8
  %n_val2 = load i64, i64* %n, align 8
  %cmp2 = icmp ult i64 %j_val, %n_val2
  br i1 %cmp2, label %loop2.body, label %loop2.end

loop2.body:
  %idx2ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j_val
  %val2 = load i32, i32* %idx2ptr, align 4
  %fmt_num2 = getelementptr inbounds [4 x i8], [4 x i8]* @.str_num, i64 0, i64 0
  %call3 = call i32 (i8*, ...) @printf(i8* %fmt_num2, i32 %val2)
  %j_next = add i64 %j_val, 1
  store i64 %j_next, i64* %j, align 8
  br label %loop2

loop2.end:
  %nlres2 = call i32 @putchar(i32 10)
  ret i32 0
}