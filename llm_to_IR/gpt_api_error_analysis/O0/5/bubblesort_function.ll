define void @bubble_sort(i32* %arr, i64 %n) {
entry:
  %small = icmp ule i64 %n, 1
  br i1 %small, label %ret, label %set_init_bound

set_init_bound:
  br label %outer_test

outer_test:
  %bound = phi i64 [ %n, %set_init_bound ], [ %bound2, %set_bound ]
  %cond = icmp ugt i64 %bound, 1
  br i1 %cond, label %outer_body, label %ret

outer_body:
  br label %inner_header

inner_header:
  %i = phi i64 [ 1, %outer_body ], [ %i_next, %after_compare ]
  %last = phi i64 [ 0, %outer_body ], [ %last_next, %after_compare ]
  %cmpi = icmp ult i64 %i, %bound
  br i1 %cmpi, label %inner_body, label %after_inner

inner_body:
  %im1 = add i64 %i, -1
  %ptrL = getelementptr inbounds i32, i32* %arr, i64 %im1
  %ptrR = getelementptr inbounds i32, i32* %arr, i64 %i
  %valL = load i32, i32* %ptrL, align 4
  %valR = load i32, i32* %ptrR, align 4
  %gt = icmp sgt i32 %valL, %valR
  br i1 %gt, label %do_swap, label %no_swap

do_swap:
  store i32 %valR, i32* %ptrL, align 4
  store i32 %valL, i32* %ptrR, align 4
  br label %after_compare

no_swap:
  br label %after_compare

after_compare:
  %last_next = phi i64 [ %i, %do_swap ], [ %last, %no_swap ]
  %i_next = add i64 %i, 1
  br label %inner_header

after_inner:
  %zero = icmp eq i64 %last, 0
  br i1 %zero, label %ret, label %set_bound

set_bound:
  %bound2 = phi i64 [ %last, %after_inner ]
  br label %outer_test

ret:
  ret void
}