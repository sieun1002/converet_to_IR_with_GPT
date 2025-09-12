; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x1325
; Intent: initialize an array, quicksort it, and print elements (confidence=0.90). Evidence: call to quick_sort(arr, 0, len-1); loop printing with "%d ".
; Preconditions: none
; Postconditions: prints 10 integers followed by a newline; returns 0

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

; Only the necessary external declarations:
declare i32 @_printf(i8*, ...)
declare i32 @_putchar(i32)
declare void @quick_sort(i32*, i64, i64)

define dso_local i32 @main() local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  ; arr = {9,1,5,3,7,2,8,6,4,0}
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

  ; if (len > 1) quick_sort(arr, 0, len-1)
  %need_sort = icmp ugt i64 10, 1
  br i1 %need_sort, label %sort, label %loop.init

sort:
  %base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %high = add i64 10, -1
  call void @quick_sort(i32* %base, i64 0, i64 %high)
  br label %loop.init

loop.init:
  br label %loop

loop:
  %i = phi i64 [ 0, %loop.init ], [ %i.next, %body ]
  %cond = icmp ult i64 %i, 10
  br i1 %cond, label %body, label %done

body:
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (...)* @_printf(i8* %fmt, i32 %elem)
  %i.next = add i64 %i, 1
  br label %loop

done:
  %nl = call i32 @_putchar(i32 10)
  ret i32 0
}