; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x1325
; Intent: initialize array, quick_sort it in-place, then print elements (confidence=0.82). Evidence: call to quick_sort with bounds [0..n-1]; loop printing with "%d " and final newline
; Preconditions: quick_sort takes (i32* base, i64 lo, i64 hi) with inclusive hi
; Postconditions: prints the (sorted) 10 integers followed by a newline; returns 0

; Only the necessary external declarations:
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @quick_sort(i32*, i64, i64)

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %len = alloca i64, align 8
  %i = alloca i64, align 8

  ; arr initialization: 9,1,5,3,7,2,8,6,4,0
  %a0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %a0, align 4
  %a1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %a1, align 4
  %a2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %a2, align 4
  %a3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %a3, align 4
  %a4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %a4, align 4
  %a5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %a5, align 4
  %a6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %a6, align 4
  %a7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %a7, align 4
  %a8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %a8, align 4
  %a9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %a9, align 4

  store i64 10, i64* %len, align 8

  ; if (len > 1) quick_sort(arr, 0, len-1)
  %lenv = load i64, i64* %len, align 8
  %cmp = icmp ugt i64 %lenv, 1
  br i1 %cmp, label %do_sort, label %post_sort

do_sort:
  %arrptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %him1 = add i64 %lenv, -1
  call void @quick_sort(i32* %arrptr, i64 0, i64 %him1)
  br label %post_sort

post_sort:
  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %iv = load i64, i64* %i, align 8
  %lenv2 = load i64, i64* %len, align 8
  %cond = icmp ult i64 %iv, %lenv2
  br i1 %cond, label %body, label %done

body:
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %iv
  %elem = load i32, i32* %elem.ptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %elem)
  %inc = add i64 %iv, 1
  store i64 %inc, i64* %i, align 8
  br label %loop

done:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}