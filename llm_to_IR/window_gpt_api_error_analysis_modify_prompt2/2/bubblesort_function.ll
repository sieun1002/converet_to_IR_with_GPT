; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

define void @bubble_sort(i32* %a, i64 %n) {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %ret, label %outer_check

outer_check:
  %limit = phi i64 [ %n, %entry ], [ %lastSwap, %outer_update ]
  %cond_outer = icmp ugt i64 %limit, 1
  br i1 %cond_outer, label %outer_body_init, label %ret

outer_body_init:
  br label %inner_check

inner_check:
  %i = phi i64 [ 1, %outer_body_init ], [ %i_next, %inc ]
  %lastSwap = phi i64 [ 0, %outer_body_init ], [ %lastSwap_next, %inc ]
  %cmp_inner = icmp ult i64 %i, %limit
  br i1 %cmp_inner, label %inner_body, label %after_inner

inner_body:
  %im1 = add i64 %i, -1
  %ptr_left = getelementptr inbounds i32, i32* %a, i64 %im1
  %left = load i32, i32* %ptr_left, align 4
  %ptr_right = getelementptr inbounds i32, i32* %a, i64 %i
  %right = load i32, i32* %ptr_right, align 4
  %cmp_le = icmp sle i32 %left, %right
  br i1 %cmp_le, label %no_swap, label %do_swap

no_swap:
  br label %inc

do_swap:
  store i32 %right, i32* %ptr_left, align 4
  store i32 %left, i32* %ptr_right, align 4
  br label %inc

inc:
  %lastSwap_next = phi i64 [ %lastSwap, %no_swap ], [ %i, %do_swap ]
  %i_next = add i64 %i, 1
  br label %inner_check

after_inner:
  %is_zero = icmp eq i64 %lastSwap, 0
  br i1 %is_zero, label %ret, label %outer_update

outer_update:
  br label %outer_check

ret:
  ret void
}