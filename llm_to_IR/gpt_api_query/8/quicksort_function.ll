; LLVM 14 IR for: void quick_sort(int* arr, long low, long high)

define void @quick_sort(i32* %arr, i64 %low, i64 %high) {
entry:
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %lo = alloca i64, align 8
  %hi = alloca i64, align 8
  %pivot = alloca i32, align 4
  %tmp = alloca i32, align 4

  store i64 %low, i64* %lo, align 8
  store i64 %high, i64* %hi, align 8
  br label %outer_loop

outer_loop:
  %lo_v = load i64, i64* %lo, align 8
  %hi_v = load i64, i64* %hi, align 8
  %cmp_lohi = icmp slt i64 %lo_v, %hi_v
  br i1 %cmp_lohi, label %partition, label %ret

partition:
  store i64 %lo_v, i64* %i, align 8
  store i64 %hi_v, i64* %j, align 8
  %diff = sub i64 %hi_v, %lo_v
  %half = sdiv i64 %diff, 2
  %mid = add i64 %lo_v, %half
  %mid_ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pv = load i32, i32* %mid_ptr, align 4
  store i32 %pv, i32* %pivot, align 4
  br label %loop_i

loop_i:
  %i_cur = load i64, i64* %i, align 8
  %i_ptr = getelementptr inbounds i32, i32* %arr, i64 %i_cur
  %ival = load i32, i32* %i_ptr, align 4
  %pv_load1 = load i32, i32* %pivot, align 4
  %cmp_i = icmp slt i32 %ival, %pv_load1
  br i1 %cmp_i, label %inc_i, label %after_i

inc_i:
  %i_next = add i64 %i_cur, 1
  store i64 %i_next, i64* %i, align 8
  br label %loop_i

after_i:
  br label %loop_j

loop_j:
  %j_cur = load i64, i64* %j, align 8
  %j_ptr = getelementptr inbounds i32, i32* %arr, i64 %j_cur
  %jval = load i32, i32* %j_ptr, align 4
  %pv_load2 = load i32, i32* %pivot, align 4
  %cmp_j = icmp sgt i32 %jval, %pv_load2
  br i1 %cmp_j, label %dec_j, label %after_j

dec_j:
  %j_prev = sub i64 %j_cur, 1
  store i64 %j_prev, i64* %j, align 8
  br label %loop_j

after_j:
  %i_now = load i64, i64* %i, align 8
  %j_now = load i64, i64* %j, align 8
  %cmp_ij = icmp sle i64 %i_now, %j_now
  br i1 %cmp_ij, label %do_swap, label %post_partition

do_swap:
  %iptr2 = getelementptr inbounds i32, i32* %arr, i64 %i_now
  %ival2 = load i32, i32* %iptr2, align 4
  store i32 %ival2, i32* %tmp, align 4
  %jptr2 = getelementptr inbounds i32, i32* %arr, i64 %j_now
  %jval2 = load i32, i32* %jptr2, align 4
  store i32 %jval2, i32* %iptr2, align 4
  %t = load i32, i32* %tmp, align 4
  store i32 %t, i32* %jptr2, align 4
  %i_inc2 = add i64 %i_now, 1
  store i64 %i_inc2, i64* %i, align 8
  %j_dec2 = sub i64 %j_now, 1
  store i64 %j_dec2, i64* %j, align 8
  br label %loop_i

post_partition:
  %lo2 = load i64, i64* %lo, align 8
  %hi2 = load i64, i64* %hi, align 8
  %i_end = load i64, i64* %i, align 8
  %j_end = load i64, i64* %j, align 8
  %left_len = sub i64 %j_end, %lo2
  %right_len = sub i64 %hi2, %i_end
  %cond_left_smaller = icmp slt i64 %left_len, %right_len
  br i1 %cond_left_smaller, label %recurse_left, label %recurse_right

recurse_left:
  %need_left = icmp slt i64 %lo2, %j_end
  br i1 %need_left, label %call_left, label %skip_left

call_left:
  call void @quick_sort(i32* %arr, i64 %lo2, i64 %j_end)
  br label %skip_left

skip_left:
  store i64 %i_end, i64* %lo, align 8
  br label %outer_loop

recurse_right:
  %need_right = icmp slt i64 %i_end, %hi2
  br i1 %need_right, label %call_right, label %skip_right

call_right:
  call void @quick_sort(i32* %arr, i64 %i_end, i64 %hi2)
  br label %skip_right

skip_right:
  store i64 %j_end, i64* %hi, align 8
  br label %outer_loop

ret:
  ret void
}