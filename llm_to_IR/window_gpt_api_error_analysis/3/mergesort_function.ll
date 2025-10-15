; ModuleID = 'merge_sort_module'
target triple = "x86_64-pc-windows-msvc"

declare i8* @malloc(i64 noundef)
declare void @free(i8* noundef)
declare i8* @memcpy(i8* noundef, i8* noundef, i64 noundef)

define void @merge_sort(i32* noundef %arr, i64 noundef %n) {
entry:
  %cmp_n_small = icmp ule i64 %n, 1
  br i1 %cmp_n_small, label %ret_early, label %alloc

ret_early:
  ret void

alloc:
  %size_bytes = shl i64 %n, 2
  %blk_raw = call i8* @malloc(i64 %size_bytes)
  %blk_isnull = icmp eq i8* %blk_raw, null
  br i1 %blk_isnull, label %ret_early2, label %init

ret_early2:
  ret void

init:
  %blk_i32 = bitcast i8* %blk_raw to i32*
  %src0 = bitcast i32* %arr to i32*
  %dst0 = bitcast i32* %blk_i32 to i32*
  br label %outer_cond

outer_cond:
  %src.cur = phi i32* [ %src0, %init ], [ %src.next, %swap_and_stride ]
  %dst.cur = phi i32* [ %dst0, %init ], [ %dst.next, %swap_and_stride ]
  %stride.cur = phi i64 [ 1, %init ], [ %stride.next, %swap_and_stride ]
  %cond_outer = icmp ult i64 %stride.cur, %n
  br i1 %cond_outer, label %outer_body_init, label %after_loop

outer_body_init:
  %start0 = phi i64 [ 0, %outer_cond ]
  br label %inner_cond

inner_cond:
  %start.cur = phi i64 [ %start0, %outer_body_init ], [ %start.next, %after_merge ]
  %cmp_inner = icmp ult i64 %start.cur, %n
  br i1 %cmp_inner, label %inner_prep, label %inner_done

inner_prep:
  %left_start = add i64 %start.cur, 0
  %tmp_mid = add i64 %start.cur, %stride.cur
  %mid_le_n = icmp ule i64 %tmp_mid, %n
  %mid = select i1 %mid_le_n, i64 %tmp_mid, i64 %n
  %double_stride = shl i64 %stride.cur, 1
  %tmp_end = add i64 %start.cur, %double_stride
  %end_le_n = icmp ule i64 %tmp_end, %n
  %end = select i1 %end_le_n, i64 %tmp_end, i64 %n
  %left0.merge = add i64 %left_start, 0
  %right0.merge = add i64 %mid, 0
  %dst0.merge = add i64 %left_start, 0
  br label %merge_loop_cond

merge_loop_cond:
  %left.idx = phi i64 [ %left0.merge, %inner_prep ], [ %left.next, %write ]
  %right.idx = phi i64 [ %right0.merge, %inner_prep ], [ %right.next, %write ]
  %dst.idx = phi i64 [ %dst0.merge, %inner_prep ], [ %dst.next, %write ]
  %dst_lt_end = icmp ult i64 %dst.idx, %end
  br i1 %dst_lt_end, label %choose, label %after_merge

choose:
  %left_avail = icmp ult i64 %left.idx, %mid
  br i1 %left_avail, label %check_right, label %take_right

check_right:
  %right_avail = icmp ult i64 %right.idx, %end
  br i1 %right_avail, label %compare, label %take_left

compare:
  %lptr = getelementptr inbounds i32, i32* %src.cur, i64 %left.idx
  %lval = load i32, i32* %lptr, align 4
  %rptr = getelementptr inbounds i32, i32* %src.cur, i64 %right.idx
  %rval = load i32, i32* %rptr, align 4
  %le_cmp = icmp sle i32 %lval, %rval
  br i1 %le_cmp, label %take_left, label %take_right

take_left:
  %lptr2 = getelementptr inbounds i32, i32* %src.cur, i64 %left.idx
  %val.left = load i32, i32* %lptr2, align 4
  %left.inc = add i64 %left.idx, 1
  br label %write

take_right:
  %rptr2 = getelementptr inbounds i32, i32* %src.cur, i64 %right.idx
  %val.right = load i32, i32* %rptr2, align 4
  %right.inc = add i64 %right.idx, 1
  br label %write

write:
  %val.to.store = phi i32 [ %val.left, %take_left ], [ %val.right, %take_right ]
  %left.next = phi i64 [ %left.inc, %take_left ], [ %left.idx, %take_right ]
  %right.next = phi i64 [ %right.idx, %take_left ], [ %right.inc, %take_right ]
  %dptr = getelementptr inbounds i32, i32* %dst.cur, i64 %dst.idx
  store i32 %val.to.store, i32* %dptr, align 4
  %dst.next = add i64 %dst.idx, 1
  br label %merge_loop_cond

after_merge:
  %two_stride = shl i64 %stride.cur, 1
  %start.next = add i64 %start.cur, %two_stride
  br label %inner_cond

inner_done:
  br label %swap_and_stride

swap_and_stride:
  %src.next = phi i32* [ %dst.cur, %inner_done ]
  %dst.next = phi i32* [ %src.cur, %inner_done ]
  %stride.next = shl i64 %stride.cur, 1
  br label %outer_cond

after_loop:
  %src.final = phi i32* [ %src.cur, %outer_cond ]
  %need_copy = icmp ne i32* %src.final, %arr
  br i1 %need_copy, label %do_copy, label %skip_copy

do_copy:
  %dst_bytes = bitcast i32* %arr to i8*
  %src_bytes = bitcast i32* %src.final to i8*
  %copied = call i8* @memcpy(i8* %dst_bytes, i8* %src_bytes, i64 %size_bytes)
  br label %skip_copy

skip_copy:
  call void @free(i8* %blk_raw)
  ret void
}