target triple = "x86_64-pc-windows-msvc"

declare i8* @malloc(i64)
declare void @free(i8*)
declare i8* @memcpy(i8*, i8*, i64)

define void @merge_sort(i32* %arr, i64 %n) {
entry:
  %cmp_small = icmp ule i64 %n, 1
  br i1 %cmp_small, label %ret, label %alloc

alloc:
  %bytes = shl i64 %n, 2
  %blk = call i8* @malloc(i64 %bytes)
  %blk_isnull = icmp eq i8* %blk, null
  br i1 %blk_isnull, label %ret, label %init

init:
  %dst0 = bitcast i8* %blk to i32*
  br label %outer.cond

outer.cond:
  %run = phi i64 [ 1, %init ], [ %run_next, %outer.endpass ]
  %srcp = phi i32* [ %arr, %init ], [ %src_next, %outer.endpass ]
  %dstp = phi i32* [ %dst0, %init ], [ %dst_next, %outer.endpass ]
  %cmp_run = icmp ult i64 %run, %n
  br i1 %cmp_run, label %outer.body, label %after.outer

outer.body:
  br label %chunks

chunks:
  %start = phi i64 [ 0, %outer.body ], [ %start_next, %chunks.after ]
  %two_run = add i64 %run, %run
  %tmp_add_mid = add i64 %start, %run
  %n_ge_mid = icmp uge i64 %n, %tmp_add_mid
  %mid = select i1 %n_ge_mid, i64 %tmp_add_mid, i64 %n
  %tmp_add_end = add i64 %start, %two_run
  %n_ge_end = icmp uge i64 %n, %tmp_add_end
  %end = select i1 %n_ge_end, i64 %tmp_add_end, i64 %n
  br label %merge.loop

merge.loop:
  %i = phi i64 [ %start, %chunks ], [ %i_next, %merge.latch ]
  %j = phi i64 [ %mid, %chunks ], [ %j_next, %merge.latch ]
  %k = phi i64 [ %start, %chunks ], [ %k_next, %merge.latch ]
  %k_lt_end = icmp ult i64 %k, %end
  br i1 %k_lt_end, label %merge.body, label %chunks.after

merge.body:
  %i_lt_mid = icmp ult i64 %i, %mid
  br i1 %i_lt_mid, label %check_j, label %take_right_iend

check_j:
  %j_lt_end = icmp ult i64 %j, %end
  br i1 %j_lt_end, label %compare_vals, label %take_left_jend

compare_vals:
  %i_ptr = getelementptr inbounds i32, i32* %srcp, i64 %i
  %left = load i32, i32* %i_ptr, align 4
  %j_ptr = getelementptr inbounds i32, i32* %srcp, i64 %j
  %right = load i32, i32* %j_ptr, align 4
  %left_gt_right = icmp sgt i32 %left, %right
  br i1 %left_gt_right, label %take_right_cmp, label %take_left_cmp

take_left_jend:
  %i_ptr_jend = getelementptr inbounds i32, i32* %srcp, i64 %i
  %left_jend = load i32, i32* %i_ptr_jend, align 4
  %dst_ptr_jend = getelementptr inbounds i32, i32* %dstp, i64 %k
  store i32 %left_jend, i32* %dst_ptr_jend, align 4
  %i_next_jend = add i64 %i, 1
  %j_next_jend = add i64 %j, 0
  %k_next_jend = add i64 %k, 1
  br label %merge.latch

take_left_cmp:
  %dst_ptr_lcmp = getelementptr inbounds i32, i32* %dstp, i64 %k
  store i32 %left, i32* %dst_ptr_lcmp, align 4
  %i_next_lcmp = add i64 %i, 1
  %j_next_lcmp = add i64 %j, 0
  %k_next_lcmp = add i64 %k, 1
  br label %merge.latch

take_right_iend:
  %j_ptr_iend = getelementptr inbounds i32, i32* %srcp, i64 %j
  %right_iend = load i32, i32* %j_ptr_iend, align 4
  %dst_ptr_iend = getelementptr inbounds i32, i32* %dstp, i64 %k
  store i32 %right_iend, i32* %dst_ptr_iend, align 4
  %i_next_iend = add i64 %i, 0
  %j_next_iend = add i64 %j, 1
  %k_next_iend = add i64 %k, 1
  br label %merge.latch

take_right_cmp:
  %dst_ptr_rcmp = getelementptr inbounds i32, i32* %dstp, i64 %k
  store i32 %right, i32* %dst_ptr_rcmp, align 4
  %i_next_rcmp = add i64 %i, 0
  %j_next_rcmp = add i64 %j, 1
  %k_next_rcmp = add i64 %k, 1
  br label %merge.latch

merge.latch:
  %i_next = phi i64 [ %i_next_jend, %take_left_jend ], [ %i_next_lcmp, %take_left_cmp ], [ %i_next_iend, %take_right_iend ], [ %i_next_rcmp, %take_right_cmp ]
  %j_next = phi i64 [ %j_next_jend, %take_left_jend ], [ %j_next_lcmp, %take_left_cmp ], [ %j_next_iend, %take_right_iend ], [ %j_next_rcmp, %take_right_cmp ]
  %k_next = phi i64 [ %k_next_jend, %take_left_jend ], [ %k_next_lcmp, %take_left_cmp ], [ %k_next_iend, %take_right_iend ], [ %k_next_rcmp, %take_right_cmp ]
  br label %merge.loop

chunks.after:
  %start_next = add i64 %start, %two_run
  %cont_chunks = icmp ult i64 %start_next, %n
  br i1 %cont_chunks, label %chunks, label %outer.endpass

outer.endpass:
  %src_next = phi i32* [ %dstp, %chunks.after ]
  %dst_next = phi i32* [ %srcp, %chunks.after ]
  %run_next = shl i64 %run, 1
  br label %outer.cond

after.outer:
  %src_final = phi i32* [ %srcp, %outer.cond ]
  %cmp_src_eq = icmp eq i32* %src_final, %arr
  br i1 %cmp_src_eq, label %skip_copy, label %do_copy

do_copy:
  %bytes2 = shl i64 %n, 2
  %arr_bytes = bitcast i32* %arr to i8*
  %src_bytes = bitcast i32* %src_final to i8*
  %memcpy_res = call i8* @memcpy(i8* %arr_bytes, i8* %src_bytes, i64 %bytes2)
  br label %skip_copy

skip_copy:
  call void @free(i8* %blk)
  br label %ret

ret:
  ret void
}