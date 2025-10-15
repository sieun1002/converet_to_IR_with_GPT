target triple = "x86_64-pc-windows-msvc"

declare i8* @malloc(i64)
declare void @free(i8*)
declare i8* @memcpy(i8*, i8*, i64)

define void @merge_sort(i32* %arg0, i64 %arg8) {
entry:
  %cmp_le1 = icmp ule i64 %arg8, 1
  br i1 %cmp_le1, label %ret_early, label %alloc

alloc:
  %size = shl i64 %arg8, 2
  %mem = call i8* @malloc(i64 %size)
  %isnull = icmp eq i8* %mem, null
  br i1 %isnull, label %ret_early, label %init

init:
  %block = bitcast i8* %mem to i32*
  br label %outer_cond

outer_cond:
  %run = phi i64 [ 1, %init ], [ %run_next, %outer_latch ]
  %src = phi i32* [ %arg0, %init ], [ %tmp_cur, %outer_latch ]
  %tmp_cur = phi i32* [ %block, %init ], [ %src, %outer_latch ]
  %cmp_run = icmp ult i64 %run, %arg8
  br i1 %cmp_run, label %inner_init, label %after_outer

inner_init:
  br label %inner_cond

inner_cond:
  %i = phi i64 [ 0, %inner_init ], [ %i_next, %inner_latch ]
  %i_cmp = icmp ult i64 %i, %arg8
  br i1 %i_cmp, label %segment_prep, label %after_inner

segment_prep:
  %start = add i64 %i, 0
  %midcand = add i64 %start, %run
  %mid_ok = icmp ule i64 %midcand, %arg8
  %mid = select i1 %mid_ok, i64 %midcand, i64 %arg8
  %tworun = add i64 %run, %run
  %endcand = add i64 %start, %tworun
  %end_ok = icmp ule i64 %endcand, %arg8
  %end = select i1 %end_ok, i64 %endcand, i64 %arg8
  br label %merge_cond

merge_cond:
  %left = phi i64 [ %start, %segment_prep ], [ %left_next, %merge_update ]
  %right = phi i64 [ %mid, %segment_prep ], [ %right_next, %merge_update ]
  %dest = phi i64 [ %start, %segment_prep ], [ %dest_next, %merge_update ]
  %dest_cmp = icmp ult i64 %dest, %end
  br i1 %dest_cmp, label %compare_select, label %segment_done

compare_select:
  %left_avail = icmp ult i64 %left, %mid
  br i1 %left_avail, label %check_right, label %take_right

check_right:
  %right_avail = icmp ult i64 %right, %end
  br i1 %right_avail, label %compare_vals, label %take_left

compare_vals:
  %lptr = getelementptr inbounds i32, i32* %src, i64 %left
  %lval = load i32, i32* %lptr, align 4
  %rptr = getelementptr inbounds i32, i32* %src, i64 %right
  %rval = load i32, i32* %rptr, align 4
  %lgt = icmp sgt i32 %lval, %rval
  br i1 %lgt, label %take_right, label %take_left

take_left:
  %lptr2 = getelementptr inbounds i32, i32* %src, i64 %left
  %lval2 = load i32, i32* %lptr2, align 4
  %tptrL = getelementptr inbounds i32, i32* %tmp_cur, i64 %dest
  store i32 %lval2, i32* %tptrL, align 4
  %left_inc = add i64 %left, 1
  %dest_incL = add i64 %dest, 1
  br label %merge_update

take_right:
  %rptr2 = getelementptr inbounds i32, i32* %src, i64 %right
  %rval2 = load i32, i32* %rptr2, align 4
  %tptrR = getelementptr inbounds i32, i32* %tmp_cur, i64 %dest
  store i32 %rval2, i32* %tptrR, align 4
  %right_inc = add i64 %right, 1
  %dest_incR = add i64 %dest, 1
  br label %merge_update

merge_update:
  %left_next = phi i64 [ %left_inc, %take_left ], [ %left, %take_right ]
  %right_next = phi i64 [ %right, %take_left ], [ %right_inc, %take_right ]
  %dest_next = phi i64 [ %dest_incL, %take_left ], [ %dest_incR, %take_right ]
  br label %merge_cond

segment_done:
  %i_next = add i64 %i, %tworun
  br label %inner_latch

inner_latch:
  br label %inner_cond

after_inner:
  br label %outer_latch

outer_latch:
  %run_next = shl i64 %run, 1
  br label %outer_cond

after_outer:
  %src_eq_arg0 = icmp eq i32* %src, %arg0
  br i1 %src_eq_arg0, label %free_block, label %do_copy

do_copy:
  %bytes = shl i64 %arg8, 2
  %dst8 = bitcast i32* %arg0 to i8*
  %src8 = bitcast i32* %src to i8*
  %memcpyres = call i8* @memcpy(i8* %dst8, i8* %src8, i64 %bytes)
  br label %free_block

free_block:
  %blk8 = bitcast i32* %block to i8*
  call void @free(i8* %blk8)
  br label %ret

ret_early:
  ret void

ret:
  ret void
}