; ModuleID = 'bubble_sort.ll'

define void @bubble_sort(i32* %arr, i64 %n) {
entry:
  %n_le1 = icmp ule i64 %n, 1
  br i1 %n_le1, label %exit, label %outer_header_pre

outer_header_pre:
  br label %outer_header

outer_header:
  %last = phi i64 [ %n, %outer_header_pre ], [ %last_next, %outer_update ]
  %cond = icmp ugt i64 %last, 1
  br i1 %cond, label %inner_header_pre, label %exit

inner_header_pre:
  br label %inner_header

inner_header:
  %j = phi i64 [ 1, %inner_header_pre ], [ %j.next, %inc_join ]
  %last_swap = phi i64 [ 0, %inner_header_pre ], [ %last_swap.next, %inc_join ]
  %j_lt_last = icmp ult i64 %j, %last
  br i1 %j_lt_last, label %compare, label %inner_done

compare:
  %jminus1 = add i64 %j, -1
  %p1 = getelementptr inbounds i32, i32* %arr, i64 %jminus1
  %p2 = getelementptr inbounds i32, i32* %arr, i64 %j
  %v1 = load i32, i32* %p1, align 4
  %v2 = load i32, i32* %p2, align 4
  %le = icmp sle i32 %v1, %v2
  br i1 %le, label %inc_no_swap, label %swap

swap:
  store i32 %v2, i32* %p1, align 4
  store i32 %v1, i32* %p2, align 4
  %last_swap.swap = add i64 %j, 0
  br label %inc_join

inc_no_swap:
  br label %inc_join

inc_join:
  %last_swap.next = phi i64 [ %last_swap.swap, %swap ], [ %last_swap, %inc_no_swap ]
  %j.next = add i64 %j, 1
  br label %inner_header

inner_done:
  %no_swaps = icmp eq i64 %last_swap, 0
  br i1 %no_swaps, label %exit, label %outer_update

outer_update:
  %last_next = add i64 %last_swap, 0
  br label %outer_header

exit:
  ret void
}