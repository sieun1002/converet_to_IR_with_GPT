target triple = "x86_64-pc-windows-msvc"

define void @bubble_sort(i32* %a, i64 %n) {
entry:
  %cmp_n1 = icmp ule i64 %n, 1
  br i1 %cmp_n1, label %ret, label %preheader

preheader:
  br label %outer_check

outer_check:
  %L = phi i64 [ %n, %preheader ], [ %last_phi, %outer_update ]
  %cmp_outer = icmp ugt i64 %L, 1
  br i1 %cmp_outer, label %outer_body, label %ret

outer_body:
  br label %inner_cond

inner_cond:
  %j = phi i64 [ 1, %outer_body ], [ %j_next, %inner_latch ]
  %last_phi = phi i64 [ 0, %outer_body ], [ %last_new, %inner_latch ]
  %cmp_inner = icmp ult i64 %j, %L
  br i1 %cmp_inner, label %inner_cmp, label %after_inner

inner_cmp:
  %jm1 = add i64 %j, -1
  %ptr_jm1 = getelementptr inbounds i32, i32* %a, i64 %jm1
  %v_jm1 = load i32, i32* %ptr_jm1, align 4
  %ptr_j = getelementptr inbounds i32, i32* %a, i64 %j
  %v_j = load i32, i32* %ptr_j, align 4
  %gt = icmp sgt i32 %v_jm1, %v_j
  br i1 %gt, label %do_swap, label %no_swap

do_swap:
  store i32 %v_j, i32* %ptr_jm1, align 4
  store i32 %v_jm1, i32* %ptr_j, align 4
  br label %inner_latch

no_swap:
  br label %inner_latch

inner_latch:
  %last_new = select i1 %gt, i64 %j, i64 %last_phi
  %j_next = add i64 %j, 1
  br label %inner_cond

after_inner:
  %iszero = icmp eq i64 %last_phi, 0
  br i1 %iszero, label %ret, label %outer_update

outer_update:
  br label %outer_check

ret:
  ret void
}