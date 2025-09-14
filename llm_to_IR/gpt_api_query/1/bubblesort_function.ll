; bubble_sort: optimized bubble sort with last-swap boundary reduction
define dso_local void @bubble_sort(i32* %arr, i64 %n) {
entry:
  %cmp_init = icmp ule i64 %n, 1
  br i1 %cmp_init, label %ret, label %outer_preheader

outer_preheader:
  br label %outer_header

outer_header:
  %newn.cur = phi i64 [ %n, %outer_preheader ], [ %newn.next, %outer_latch ]
  br label %inner_cond

inner_cond:
  %i = phi i64 [ 1, %outer_header ], [ %i.next, %inner_body_end ]
  %last = phi i64 [ 0, %outer_header ], [ %last.next, %inner_body_end ]
  %cmp_i = icmp ult i64 %i, %newn.cur
  br i1 %cmp_i, label %inner_body, label %inner_exit

inner_body:
  %i_minus1 = add nsw i64 %i, -1
  %ptr_im1 = getelementptr inbounds i32, i32* %arr, i64 %i_minus1
  %ptr_i = getelementptr inbounds i32, i32* %arr, i64 %i
  %a = load i32, i32* %ptr_im1, align 4
  %b = load i32, i32* %ptr_i, align 4
  %gt = icmp sgt i32 %a, %b
  br i1 %gt, label %swap, label %noswap

swap:
  store i32 %b, i32* %ptr_im1, align 4
  store i32 %a, i32* %ptr_i, align 4
  %last.sw = add i64 %i, 0
  br label %inner_body_end

noswap:
  br label %inner_body_end

inner_body_end:
  %last.next = phi i64 [ %last.sw, %swap ], [ %last, %noswap ]
  %i.next = add nuw nsw i64 %i, 1
  br label %inner_cond

inner_exit:
  %no_swaps = icmp eq i64 %last, 0
  br i1 %no_swaps, label %ret, label %outer_latch

outer_latch:
  %newn.next = add i64 %last, 0
  %cmp_newn = icmp ugt i64 %newn.next, 1
  br i1 %cmp_newn, label %outer_header, label %ret

ret:
  ret void
}