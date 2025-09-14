; ModuleID = 'bubble_sort'
target triple = "x86_64-pc-linux-gnu"

define void @bubble_sort(i32* %arr, i64 %n) {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %ret, label %init

init:
  br label %check_end

check_end:
  %end = phi i64 [ %n, %init ], [ %last_after2, %after_inner_updated ]
  %cond_end = icmp ugt i64 %end, 1
  br i1 %cond_end, label %outer_body, label %ret

outer_body:
  br label %inner_check

inner_check:
  %i = phi i64 [ 1, %outer_body ], [ %i_next, %inner_continue ]
  %last_phi = phi i64 [ 0, %outer_body ], [ %last_updated, %inner_continue ]
  %cmp_i = icmp ult i64 %i, %end
  br i1 %cmp_i, label %inner_body, label %after_inner

inner_body:
  %i_minus1 = add i64 %i, -1
  %ptr_prev = getelementptr inbounds i32, i32* %arr, i64 %i_minus1
  %prev = load i32, i32* %ptr_prev, align 4
  %ptr_curr = getelementptr inbounds i32, i32* %arr, i64 %i
  %curr = load i32, i32* %ptr_curr, align 4
  %cmp_gt = icmp sgt i32 %prev, %curr
  br i1 %cmp_gt, label %do_swap, label %no_swap

do_swap:
  store i32 %curr, i32* %ptr_prev, align 4
  store i32 %prev, i32* %ptr_curr, align 4
  br label %inner_continue

no_swap:
  br label %inner_continue

inner_continue:
  %last_updated = phi i64 [ %i, %do_swap ], [ %last_phi, %no_swap ]
  %i_next = add i64 %i, 1
  br label %inner_check

after_inner:
  %last_after = phi i64 [ %last_phi, %inner_check ]
  %is_zero = icmp eq i64 %last_after, 0
  br i1 %is_zero, label %ret, label %after_inner_updated

after_inner_updated:
  %last_after2 = phi i64 [ %last_after, %after_inner ]
  br label %check_end

ret:
  ret void
}