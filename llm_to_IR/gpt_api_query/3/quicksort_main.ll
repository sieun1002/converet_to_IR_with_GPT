; ModuleID = 'recovered.ll'
source_filename = "main"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @quick_sort(i32* noundef, i64 noundef, i64 noundef)
declare i32 @printf(i8* noundef, ...)
declare i32 @putchar(i32 noundef)

define i32 @main(i32 %argc, i8** %argv) {
entry:
  %arr = alloca [10 x i32], align 16
  %len = alloca i64, align 8
  %i = alloca i64, align 8

  ; initialize array
  %arr0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr0, align 4
  %arr1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %arr1, align 4
  %arr2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %arr2, align 4
  %arr3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %arr3, align 4
  %arr4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %arr4, align 4
  %arr5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %arr5, align 4
  %arr6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %arr6, align 4
  %arr7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr7, align 4
  %arr8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %arr8, align 4
  %arr9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %arr9, align 4

  store i64 10, i64* %len, align 8

  ; if (len > 1) quick_sort(arr, 0, len-1)
  %lenv = load i64, i64* %len, align 8
  %cmp = icmp ule i64 %lenv, 1
  br i1 %cmp, label %after_sort, label %do_sort

do_sort:                                          ; preds = %entry
  %lenv2 = load i64, i64* %len, align 8
  %high = add i64 %lenv2, -1
  %arrptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  call void @quick_sort(i32* noundef %arrptr, i64 noundef 0, i64 noundef %high)
  br label %after_sort

after_sort:                                       ; preds = %do_sort, %entry
  store i64 0, i64* %i, align 8
  br label %loop

loop:                                             ; preds = %loop_body, %after_sort
  %iv = load i64, i64* %i, align 8
  %lenv3 = load i64, i64* %len, align 8
  %cmp2 = icmp ult i64 %iv, %lenv3
  br i1 %cmp2, label %loop_body, label %done

loop_body:                                        ; preds = %loop
  %elem_ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %iv
  %elem = load i32, i32* %elem_ptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* noundef %fmtptr, i32 noundef %elem)
  %iv2 = add i64 %iv, 1
  store i64 %iv2, i64* %i, align 8
  br label %loop

done:                                             ; preds = %loop
  %nl = call i32 @putchar(i32 noundef 10)
  ret i32 0
}