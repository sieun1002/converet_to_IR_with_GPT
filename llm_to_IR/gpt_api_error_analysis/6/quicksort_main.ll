; ModuleID = 'quick_sort_main'
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @quick_sort(i32* noundef, i32 noundef, i64 noundef)
declare i32 @printf(i8* noundef, ...)
declare i32 @putchar(i32 noundef)

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %len = alloca i64, align 8
  %gep0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %gep0, align 4
  %gep1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %gep1, align 4
  %gep2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %gep2, align 4
  %gep3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %gep3, align 4
  %gep4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %gep4, align 4
  %gep5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %gep5, align 4
  %gep6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %gep6, align 4
  %gep7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %gep7, align 4
  %gep8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %gep8, align 4
  %gep9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %gep9, align 4
  store i64 10, i64* %len, align 8
  %lenv = load i64, i64* %len, align 8
  %len_le1 = icmp ule i64 %lenv, 1
  br i1 %len_le1, label %loop_init, label %do_sort

do_sort:
  %baseptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %high = add i64 %lenv, -1
  call void @quick_sort(i32* noundef %baseptr, i32 noundef 0, i64 noundef %high)
  br label %loop_init

loop_init:
  br label %loop

loop:
  %i = phi i64 [ 0, %loop_init ], [ %next, %after_print ]
  %cur_len = load i64, i64* %len, align 8
  %cond = icmp ult i64 %i, %cur_len
  br i1 %cond, label %print, label %done

print:
  %elem_ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i
  %elem = load i32, i32* %elem_ptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call_printf = call i32 (i8*, ...) @printf(i8* noundef %fmtptr, i32 noundef %elem)
  br label %after_print

after_print:
  %next = add i64 %i, 1
  br label %loop

done:
  %call_putchar = call i32 @putchar(i32 noundef 10)
  ret i32 0
}