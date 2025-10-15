; ModuleID = 'qs_module'
target triple = "x86_64-pc-windows-msvc"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare dso_local i32 @printf(i8* noundef, ...)
declare dso_local i32 @putchar(i32 noundef)

define dso_local void @__main() {
entry:
  ret void
}

define dso_local void @quick_sort(i32* noundef %arr, i32 noundef %low, i32 noundef %high) {
entry:
  %cmp = icmp slt i32 %low, %high
  br i1 %cmp, label %part, label %exit

part:
  %high_sext = sext i32 %high to i64
  %pivot_ptr = getelementptr inbounds i32, i32* %arr, i64 %high_sext
  %pivot = load i32, i32* %pivot_ptr, align 4
  %i_init = add i32 %low, -1
  br label %loop

loop:
  %i_cur = phi i32 [ %i_init, %part ], [ %i_next2, %loop_cont ]
  %j_cur = phi i32 [ %low, %part ], [ %j_next, %loop_cont ]
  %high_minus1 = add i32 %high, -1
  %cond_j = icmp sle i32 %j_cur, %high_minus1
  br i1 %cond_j, label %loop_body, label %after_loop

loop_body:
  %j_sext = sext i32 %j_cur to i64
  %elem_ptr = getelementptr inbounds i32, i32* %arr, i64 %j_sext
  %elem_val = load i32, i32* %elem_ptr, align 4
  %cmp_le = icmp sle i32 %elem_val, %pivot
  br i1 %cmp_le, label %if_then, label %if_else

if_then:
  %i_inc = add i32 %i_cur, 1
  %i_sext = sext i32 %i_inc to i64
  %i_ptr = getelementptr inbounds i32, i32* %arr, i64 %i_sext
  %i_val = load i32, i32* %i_ptr, align 4
  store i32 %elem_val, i32* %i_ptr, align 4
  store i32 %i_val, i32* %elem_ptr, align 4
  br label %loop_cont

if_else:
  br label %loop_cont

loop_cont:
  %i_next2 = phi i32 [ %i_inc, %if_then ], [ %i_cur, %if_else ]
  %j_next = add i32 %j_cur, 1
  br label %loop

after_loop:
  %pindex = add i32 %i_cur, 1
  %pindex_sext = sext i32 %pindex to i64
  %pindex_ptr = getelementptr inbounds i32, i32* %arr, i64 %pindex_sext
  %pindex_val = load i32, i32* %pindex_ptr, align 4
  store i32 %pivot, i32* %pindex_ptr, align 4
  store i32 %pindex_val, i32* %pivot_ptr, align 4
  %left_high = add i32 %pindex, -1
  call void @quick_sort(i32* noundef %arr, i32 noundef %low, i32 noundef %left_high)
  %right_low = add i32 %pindex, 1
  call void @quick_sort(i32* noundef %arr, i32 noundef %right_low, i32 noundef %high)
  br label %exit

exit:
  ret void
}

define dso_local i32 @main() {
entry:
  call void @__main()
  %arr = alloca [10 x i32], align 16
  %arr_base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %idx0 = getelementptr inbounds i32, i32* %arr_base, i64 0
  store i32 9, i32* %idx0, align 4
  %idx1 = getelementptr inbounds i32, i32* %arr_base, i64 1
  store i32 1, i32* %idx1, align 4
  %idx2 = getelementptr inbounds i32, i32* %arr_base, i64 2
  store i32 5, i32* %idx2, align 4
  %idx3 = getelementptr inbounds i32, i32* %arr_base, i64 3
  store i32 3, i32* %idx3, align 4
  %idx4 = getelementptr inbounds i32, i32* %arr_base, i64 4
  store i32 7, i32* %idx4, align 4
  %idx5 = getelementptr inbounds i32, i32* %arr_base, i64 5
  store i32 2, i32* %idx5, align 4
  %idx6 = getelementptr inbounds i32, i32* %arr_base, i64 6
  store i32 8, i32* %idx6, align 4
  %idx7 = getelementptr inbounds i32, i32* %arr_base, i64 7
  store i32 6, i32* %idx7, align 4
  %idx8 = getelementptr inbounds i32, i32* %arr_base, i64 8
  store i32 4, i32* %idx8, align 4
  %idx9 = getelementptr inbounds i32, i32* %arr_base, i64 9
  store i32 0, i32* %idx9, align 4
  %n = add i32 10, 0
  %cmpn = icmp ugt i32 %n, 1
  br i1 %cmpn, label %do_sort, label %after_sort

do_sort:
  %high = add i32 %n, -1
  call void @quick_sort(i32* noundef %arr_base, i32 noundef 0, i32 noundef %high)
  br label %after_sort

after_sort:
  br label %loop

loop:
  %i = phi i32 [ 0, %after_sort ], [ %i_next, %loop_body ]
  %cond = icmp ult i32 %i, %n
  br i1 %cond, label %loop_body, label %done

loop_body:
  %i_sext = sext i32 %i to i64
  %elem_ptr2 = getelementptr inbounds i32, i32* %arr_base, i64 %i_sext
  %elem_val2 = load i32, i32* %elem_ptr2, align 4
  %fmt_ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %callp = call i32 (i8*, ...) @printf(i8* noundef %fmt_ptr, i32 noundef %elem_val2)
  %i_next = add i32 %i, 1
  br label %loop

done:
  %ch = call i32 @putchar(i32 noundef 10)
  ret i32 0
}