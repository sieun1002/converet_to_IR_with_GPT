; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x1325
; Intent: initialize an array, quick-sort it, then print elements (confidence=0.90). Evidence: call to quick_sort(arr, 0, n-1) and loop printing "%d ".
; Preconditions:
; Postconditions: prints sorted numbers followed by newline; returns 0

; Only the necessary external declarations:
declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @putchar(i32)
declare dso_local void @quick_sort(i32*, i64, i64)

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %i = alloca i64, align 8
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

  %nval = load i64, i64* %n, align 8
  %cmp = icmp ugt i64 %nval, 1
  br i1 %cmp, label %sort, label %after_sort

sort:
  %arr_base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %nminus1 = add i64 %nval, -1
  call void @quick_sort(i32* %arr_base, i64 0, i64 %nminus1)
  br label %after_sort

after_sort:
  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %iv = load i64, i64* %i, align 8
  %ncur = load i64, i64* %n, align 8
  %cond = icmp ult i64 %iv, %ncur
  br i1 %cond, label %loop_body, label %loop_exit

loop_body:
  %elem_ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %iv
  %elem = load i32, i32* %elem_ptr, align 4
  %fmtptr = bitcast [4 x i8]* @.str to i8*
  %callp = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %elem)
  %inc = add i64 %iv, 1
  store i64 %inc, i64* %i, align 8
  br label %loop

loop_exit:
  %c = call i32 @putchar(i32 10)
  ret i32 0
}