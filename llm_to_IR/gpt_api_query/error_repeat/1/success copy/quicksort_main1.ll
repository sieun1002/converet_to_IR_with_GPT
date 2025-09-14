; ModuleID = 'main_from_disasm'
source_filename = "main_from_disasm.ll"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @quick_sort(i32* %arr, i64 %low, i64 %high)
declare i32 @printf(i8* %fmt, ...)
declare i32 @putchar(i32 %c)

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %i = alloca i64, align 8
  %n = alloca i64, align 8

  ; n = 10
  store i64 10, i64* %n, align 8

  ; initialize array: {9,1,5,3,7,2,8,6,4,0}
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

  ; if (n > 1) quick_sort(arr, 0, n-1)
  %nval0 = load i64, i64* %n, align 8
  %cmp_n = icmp ugt i64 %nval0, 1
  br i1 %cmp_n, label %do_sort, label %after_sort

do_sort:
  %nminus1 = add i64 %nval0, -1
  %arr_base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  call void @quick_sort(i32* %arr_base, i64 0, i64 %nminus1)
  br label %after_sort

after_sort:
  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %iv = load i64, i64* %i, align 8
  %nval1 = load i64, i64* %n, align 8
  %cond = icmp ult i64 %iv, %nval1
  br i1 %cond, label %body, label %endloop

body:
  %elem_ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %iv
  %elem = load i32, i32* %elem_ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call_printf = call i32 (i8*, ...) @printf(i8* %fmt, i32 %elem)
  %iv_next = add i64 %iv, 1
  store i64 %iv_next, i64* %i, align 8
  br label %loop

endloop:
  %call_putchar = call i32 @putchar(i32 10)
  ret i32 0
}