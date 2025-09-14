; ModuleID = 'merge_sort_module'
declare i8* @malloc(i64)
declare void @free(i8*)
declare i8* @memcpy(i8*, i8*, i64)

define void @merge_sort(i32* %dest, i64 %n) {
entry:
  %cmp_n_le_1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le_1, label %ret, label %alloc

alloc:
  %n_bytes = shl i64 %n, 2
  %tmp_i8 = call i8* @malloc(i64 %n_bytes)
  %isnull = icmp eq i8* %tmp_i8, null
  br i1 %isnull, label %ret, label %init

init:
  %buf_orig = bitcast i8* %tmp_i8 to i32*
  br label %outer

outer:
  %block = phi i64 [ 1, %init ], [ %block.next, %swap_done ]
  %src.ptr = phi i32* [ %dest, %init ], [ %src.next, %swap_done ]
  %buf.ptr = phi i32* [ %buf_orig, %init ], [ %buf.next, %swap_done ]
  %cmp_block = icmp ult i64 %block, %n
  br i1 %cmp_block, label %for.preheader, label %after_outer

for.preheader:
  br label %for.loop

for.loop:
  %start = phi i64 [ 0, %for.preheader ], [ %start.next, %for.latch ]
  %has_more = icmp ult i64 %start, %n
  br i1 %has_more, label %merge.init, label %for.exit

merge.init:
  %t1 = add i64 %start, %block
  %mid_lt_n = icmp ult i64 %t1, %n
  %mid = select i1 %mid_lt_n, i64 %t1, i64 %n
  %dbl = add i64 %block, %block
  %t2 = add i64 %start, %dbl
  %right_lt_n = icmp ult i64 %t2, %n
  %right = select i1 %right_lt_n, i64 %t2, i64 %n
  %i0 = add i64 %start, 0
  %j0 = add i64 %mid, 0
  %k0 = add i64 %start, 0
  br label %merge.cond

merge.cond:
  %k = phi i64 [ %k0, %merge.init ], [ %k.next, %after_store ]
  %i = phi i64 [ %i0, %merge.init ], [ %i.next, %after_store ]
  %j = phi i64 [ %j0, %merge.init ], [ %j.next, %after_store ]
  %k_lt_right = icmp ult i64 %k, %right
  br i1 %k_lt_right, label %choose, label %merge.done

choose:
  %i_lt_mid = icmp ult i64 %i, %mid
  br i1 %i_lt_mid, label %check_j, label %take_right_load

check_j:
  %j_lt_right = icmp ult i64 %j, %right
  br i1 %j_lt_right, label %compare_vals, label %take_left_load

compare_vals:
  %li_ptr = getelementptr inbounds i32, i32* %src.ptr, i64 %i
  %lv = load i32, i32* %li_ptr, align 4
  %rj_ptr = getelementptr inbounds i32, i32* %src.ptr, i64 %j
  %rv = load i32, i32* %rj_ptr, align 4
  %l_gt_r = icmp sgt i32 %lv, %rv
  br i1 %l_gt_r, label %take_right_from_cmp, label %store_left_from_cmp

take_left_load:
  %li_ptr2 = getelementptr inbounds i32, i32* %src.ptr, i64 %i
  %lv2 = load i32, i32* %li_ptr2, align 4
  %dstptr2 = getelementptr inbounds i32, i32* %buf.ptr, i64 %k
  store i32 %lv2, i32* %dstptr2, align 4
  %i.next2 = add i64 %i, 1
  %k.next2 = add i64 %k, 1
  br label %after_store

store_left_from_cmp:
  %dstptr = getelementptr inbounds i32, i32* %buf.ptr, i64 %k
  store i32 %lv, i32* %dstptr, align 4
  %i.next1 = add i64 %i, 1
  %k.next1 = add i64 %k, 1
  br label %after_store

take_right_load:
  %rj_ptr2 = getelementptr inbounds i32, i32* %src.ptr, i64 %j
  %rv2 = load i32, i32* %rj_ptr2, align 4
  br label %take_right_common

take_right_from_cmp:
  br label %take_right_common

take_right_common:
  %rv.phi = phi i32 [ %rv, %take_right_from_cmp ], [ %rv2, %take_right_load ]
  %dstptrR = getelementptr inbounds i32, i32* %buf.ptr, i64 %k
  store i32 %rv.phi, i32* %dstptrR, align 4
  %j.nextR = add i64 %j, 1
  %k.nextR = add i64 %k, 1
  br label %after_store

after_store:
  %i.next = phi i64 [ %i.next1, %store_left_from_cmp ], [ %i.next2, %take_left_load ], [ %i, %take_right_common ]
  %j.next = phi i64 [ %j, %store_left_from_cmp ], [ %j, %take_left_load ], [ %j.nextR, %take_right_common ]
  %k.next = phi i64 [ %k.next1, %store_left_from_cmp ], [ %k.next2, %take_left_load ], [ %k.nextR, %take_right_common ]
  br label %merge.cond

merge.done:
  %start.next = add i64 %start, %dbl
  br label %for.latch

for.latch:
  br label %for.loop

for.exit:
  ; swap src and buf
  %src.next = %buf.ptr
  %buf.next = %src.ptr
  %block.next = shl i64 %block, 1
  br label %swap_done

swap_done:
  br label %outer

after_outer:
  %src_eq_dest = icmp eq i32* %src.ptr, %dest
  br i1 %src_eq_dest, label %do_free, label %do_copy

do_copy:
  %dest_i8 = bitcast i32* %dest to i8*
  %src_i8 = bitcast i32* %src.ptr to i8*
  %_ = call i8* @memcpy(i8* %dest_i8, i8* %src_i8, i64 %n_bytes)
  br label %do_free

do_free:
  call void @free(i8* %tmp_i8)
  br label %ret

ret:
  ret void
}