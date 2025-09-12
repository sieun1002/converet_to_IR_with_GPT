; ModuleID = 'quick_sort'
source_filename = "quick_sort"

define void @quick_sort(i32* nocapture %base, i64 %lo, i64 %hi) local_unnamed_addr {
entry:
  %loVar = alloca i64, align 8
  %hiVar = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %pivot = alloca i32, align 4
  %tmp = alloca i32, align 4
  store i64 %lo, i64* %loVar, align 8
  store i64 %hi, i64* %hiVar, align 8
  br label %loop

loop:
  %curr_lo = load i64, i64* %loVar, align 8
  %curr_hi = load i64, i64* %hiVar, align 8
  %cmp = icmp slt i64 %curr_lo, %curr_hi
  br i1 %cmp, label %part_init, label %ret

part_init:
  store i64 %curr_lo, i64* %i, align 8
  store i64 %curr_hi, i64* %j, align 8
  %d = sub i64 %curr_hi, %curr_lo
  %half = ashr i64 %d, 1
  %mid = add i64 %curr_lo, %half
  %pivptr = getelementptr inbounds i32, i32* %base, i64 %mid
  %piv = load i32, i32* %pivptr, align 4
  store i32 %piv, i32* %pivot, align 4
  br label %scan_i

inc_i:
  %i_val0 = load i64, i64* %i, align 8
  %i_inc = add i64 %i_val0, 1
  store i64 %i_inc, i64* %i, align 8
  br label %scan_i

scan_i:
  %i_val = load i64, i64* %i, align 8
  %i_ptr = getelementptr inbounds i32, i32* %base, i64 %i_val
  %ai = load i32, i32* %i_ptr, align 4
  %piv1 = load i32, i32* %pivot, align 4
  %cmp_i = icmp sgt i32 %piv1, %ai
  br i1 %cmp_i, label %inc_i, label %scan_j

dec_j:
  %j_val0 = load i64, i64* %j, align 8
  %j_dec = add i64 %j_val0, -1
  store i64 %j_dec, i64* %j, align 8
  br label %scan_j

scan_j:
  %j_val = load i64, i64* %j, align 8
  %j_ptr = getelementptr inbounds i32, i32* %base, i64 %j_val
  %aj = load i32, i32* %j_ptr, align 4
  %piv2 = load i32, i32* %pivot, align 4
  %cmp_j = icmp slt i32 %piv2, %aj
  br i1 %cmp_j, label %dec_j, label %after_scan

after_scan:
  %i_now = load i64, i64* %i, align 8
  %j_now = load i64, i64* %j, align 8
  %le = icmp sle i64 %i_now, %j_now
  br i1 %le, label %do_swap, label %partition_done

do_swap:
  %i_ptr2 = getelementptr inbounds i32, i32* %base, i64 %i_now
  %ai2 = load i32, i32* %i_ptr2, align 4
  store i32 %ai2, i32* %tmp, align 4
  %j_ptr2 = getelementptr inbounds i32, i32* %base, i64 %j_now
  %aj2 = load i32, i32* %j_ptr2, align 4
  store i32 %aj2, i32* %i_ptr2, align 4
  %tmpv = load i32, i32* %tmp, align 4
  store i32 %tmpv, i32* %j_ptr2, align 4
  %i_inc2 = add i64 %i_now, 1
  store i64 %i_inc2, i64* %i, align 8
  %j_dec2 = add i64 %j_now, -1
  store i64 %j_dec2, i64* %j, align 8
  br label %check_after_swap

check_after_swap:
  %i_as = load i64, i64* %i, align 8
  %j_as = load i64, i64* %j, align 8
  %le2 = icmp sle i64 %i_as, %j_as
  br i1 %le2, label %scan_i, label %partition_done

partition_done:
  %j_end = load i64, i64* %j, align 8
  %left_size = sub i64 %j_end, %curr_lo
  %i_end = load i64, i64* %i, align 8
  %right_size = sub i64 %curr_hi, %i_end
  %cmp_sizes = icmp sge i64 %left_size, %right_size
  br i1 %cmp_sizes, label %recurse_right_first, label %recurse_left_first

recurse_left_first:
  %cond_left = icmp slt i64 %curr_lo, %j_end
  br i1 %cond_left, label %call_left, label %set_lo_right

call_left:
  call void @quick_sort(i32* %base, i64 %curr_lo, i64 %j_end)
  br label %set_lo_right

set_lo_right:
  %i_end2 = load i64, i64* %i, align 8
  store i64 %i_end2, i64* %loVar, align 8
  br label %loop

recurse_right_first:
  %cond_right = icmp slt i64 %i_end, %curr_hi
  br i1 %cond_right, label %call_right, label %set_hi_left

call_right:
  call void @quick_sort(i32* %base, i64 %i_end, i64 %curr_hi)
  br label %set_hi_left

set_hi_left:
  store i64 %j_end, i64* %hiVar, align 8
  br label %loop

ret:
  ret void
}