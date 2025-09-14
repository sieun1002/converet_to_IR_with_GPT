; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x1325
; Intent: Initialize an array, quick-sort it, then print the elements (confidence=0.77). Evidence: call quick_sort(a, 0, len-1); loop printing with "%d ".
; Preconditions: quick_sort accepts (int*, long, long) as (base, left, right)
; Postconditions: prints the sorted numbers and returns 0

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@__stack_chk_guard = external global i64

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @quick_sort(i32*, i64, i64)
declare void @__stack_chk_fail()

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %len = alloca i64, align 8
  %i = alloca i64, align 8
  %canary = alloca i64, align 8

  ; stack protector setup
  %guard = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard, i64* %canary, align 8

  ; initialize array: [9,1,5,3,7,2,8,6,4,0]
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
  %len.v = load i64, i64* %len, align 8
  %cmp.le1 = icmp ule i64 %len.v, 1
  br i1 %cmp.le1, label %after_sort, label %do_sort

do_sort:
  %base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %right = add i64 %len.v, -1
  call void @quick_sort(i32* %base, i64 0, i64 %right)
  br label %after_sort

after_sort:
  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %iv = load i64, i64* %i, align 8
  %len.v2 = load i64, i64* %len, align 8
  %cont = icmp ult i64 %iv, %len.v2
  br i1 %cont, label %body, label %done

body:
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %iv
  %val = load i32, i32* %elem.ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt, i32 %val)
  %inc = add i64 %iv, 1
  store i64 %inc, i64* %i, align 8
  br label %loop

done:
  %nl = call i32 @putchar(i32 10)

  ; stack protector check
  %guard2 = load i64, i64* @__stack_chk_guard, align 8
  %saved = load i64, i64* %canary, align 8
  %ok = icmp eq i64 %guard2, %saved
  br i1 %ok, label %ret, label %fail

fail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}