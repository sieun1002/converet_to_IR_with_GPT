; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@.str = private unnamed_addr constant [4 x i8] c"%d \00"

declare void @quick_sort(i32*, i32, i32)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define i32 @main() {
entry:
  %arr = alloca [10 x i32]
  %arr_gep0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr_gep0
  %arr_gep1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %arr_gep1
  %arr_gep2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %arr_gep2
  %arr_gep3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %arr_gep3
  %arr_gep4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %arr_gep4
  %arr_gep5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %arr_gep5
  %arr_gep6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %arr_gep6
  %arr_gep7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr_gep7
  %arr_gep8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %arr_gep8
  %arr_gep9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %arr_gep9
  %n = add i64 10, 0
  %cmp_init = icmp ule i64 %n, 1
  br i1 %cmp_init, label %after_sort, label %do_sort

do_sort:
  %arr_base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %n_minus1 = add i64 %n, -1
  %hi = trunc i64 %n_minus1 to i32
  call void @quick_sort(i32* %arr_base, i32 0, i32 %hi)
  br label %after_sort

after_sort:
  br label %loop

loop:
  %i = phi i64 [ 0, %after_sort ], [ %i.next, %loop.body ]
  %cond = icmp ult i64 %i, %n
  br i1 %cond, label %loop.body, label %exit

loop.body:
  %elem_ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i
  %elem = load i32, i32* %elem_ptr
  %fmt_ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call_printf = call i32 (i8*, ...) @printf(i8* %fmt_ptr, i32 %elem)
  %i.next = add i64 %i, 1
  br label %loop

exit:
  %call_putchar = call i32 @putchar(i32 10)
  ret i32 0
}