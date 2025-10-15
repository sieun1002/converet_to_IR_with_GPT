target triple = "x86_64-pc-windows-msvc"

define dso_local void @bubble_sort(i32* %arr, i64 %n) {
entry:
  %cmp0 = icmp ule i64 %n, 1
  br i1 %cmp0, label %exit, label %outer_check_init

outer_check_init:
  br label %outer_check

outer_check:
  %m = phi i64 [ %n, %outer_check_init ], [ %m_next, %outer_update ]
  %cond_outer = icmp ugt i64 %m, 1
  br i1 %cond_outer, label %outer_body, label %exit

outer_body:
  br label %inner_check

inner_check:
  %j = phi i64 [ 1, %outer_body ], [ %j_next, %inner_latch ]
  %last = phi i64 [ 0, %outer_body ], [ %last_updated, %inner_latch ]
  %cmp_inner = icmp ult i64 %j, %m
  br i1 %cmp_inner, label %inner_body, label %inner_done

inner_body:
  %j_minus1 = add i64 %j, -1
  %ptr_prev = getelementptr inbounds i32, i32* %arr, i64 %j_minus1
  %a = load i32, i32* %ptr_prev, align 4
  %ptr_cur = getelementptr inbounds i32, i32* %arr, i64 %j
  %b = load i32, i32* %ptr_cur, align 4
  %cmpab = icmp sle i32 %a, %b
  br i1 %cmpab, label %no_swap, label %do_swap

no_swap:
  br label %inner_latch

do_swap:
  store i32 %b, i32* %ptr_prev, align 4
  store i32 %a, i32* %ptr_cur, align 4
  br label %inner_latch

inner_latch:
  %last_updated = phi i64 [ %last, %no_swap ], [ %j, %do_swap ]
  %j_next = add i64 %j, 1
  br label %inner_check

inner_done:
  %is_zero = icmp eq i64 %last, 0
  br i1 %is_zero, label %exit, label %outer_update

outer_update:
  %m_next = add i64 %last, 0
  br label %outer_check

exit:
  ret void
}