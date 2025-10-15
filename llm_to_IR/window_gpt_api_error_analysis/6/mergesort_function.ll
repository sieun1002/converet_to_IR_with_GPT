; ModuleID = 'merge_sort_module'
target triple = "x86_64-pc-windows-msvc"

declare i8* @malloc(i64)
declare void @free(i8*)
declare i8* @memcpy(i8*, i8*, i64)

define void @merge_sort(i32* %arr, i64 %n) {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %return, label %alloc

alloc:
  %size_bytes = shl i64 %n, 2
  %tmp_raw = call i8* @malloc(i64 %size_bytes)
  %isnull = icmp eq i8* %tmp_raw, null
  br i1 %isnull, label %return, label %init

init:
  %tmp_init = bitcast i8* %tmp_raw to i32*
  br label %outer

outer:
  %width = phi i64 [ 1, %init ], [ %width.next, %after_inner ]
  %src.phi = phi i32* [ %arr, %init ], [ %src.next, %after_inner ]
  %tmp.phi = phi i32* [ %tmp_init, %init ], [ %tmp.next, %after_inner ]
  %cmp_outer = icmp ult i64 %width, %n
  br i1 %cmp_outer, label %inner.init, label %after_outer

inner.init:
  br label %inner

inner:
  %start = phi i64 [ 0, %inner.init ], [ %start.next, %merged ]
  br label %check_inner

check_inner:
  %cmp_start = icmp ult i64 %start, %n
  br i1 %cmp_start, label %compute_bounds, label %after_inner

compute_bounds:
  %sum_sw = add i64 %start, %width
  %mid.cmp = icmp ult i64 %sum_sw, %n
  %mid = select i1 %mid.cmp, i64 %sum_sw, i64 %n
  %tw = add i64 %width, %width
  %sum_two = add i64 %start, %tw
  %end.cmp = icmp ult i64 %sum_two, %n
  %end = select i1 %end.cmp, i64 %sum_two, i64 %n
  br label %merge

merge:
  %i = phi i64 [ %start, %compute_bounds ], [ %i.next, %merge.body.done ]
  %j = phi i64 [ %mid, %compute_bounds ], [ %j.next, %merge.body.done ]
  %k = phi i64 [ %start, %compute_bounds ], [ %k.next, %merge.body.done ]
  %cmp_k = icmp ult i64 %k, %end
  br i1 %cmp_k, label %merge.body, label %merged

merge.body:
  %i.lt.mid = icmp ult i64 %i, %mid
  %j.lt.end = icmp ult i64 %j, %end
  br i1 %i.lt.mid, label %i_in, label %take_right_only

i_in:
  br i1 %j.lt.end, label %both_in, label %take_left_only

both_in:
  %ptr_i = getelementptr inbounds i32, i32* %src.phi, i64 %i
  %val_i = load i32, i32* %ptr_i, align 4
  %ptr_j = getelementptr inbounds i32, i32* %src.phi, i64 %j
  %val_j = load i32, i32* %ptr_j, align 4
  %cmp_vals = icmp sle i32 %val_i, %val_j
  br i1 %cmp_vals, label %take_left_both, label %take_right

take_left_both:
  %dst_ptr_l = getelementptr inbounds i32, i32* %tmp.phi, i64 %k
  store i32 %val_i, i32* %dst_ptr_l, align 4
  %i.next.l = add i64 %i, 1
  %j.next.l = add i64 %j, 0
  %k.next.l = add i64 %k, 1
  br label %merge.body.done

take_right:
  %dst_ptr_r = getelementptr inbounds i32, i32* %tmp.phi, i64 %k
  store i32 %val_j, i32* %dst_ptr_r, align 4
  %i.next.r = add i64 %i, 0
  %j.next.r = add i64 %j, 1
  %k.next.r = add i64 %k, 1
  br label %merge.body.done

take_left_only:
  %ptr_i2 = getelementptr inbounds i32, i32* %src.phi, i64 %i
  %val_i2 = load i32, i32* %ptr_i2, align 4
  %dst_ptr_lo = getelementptr inbounds i32, i32* %tmp.phi, i64 %k
  store i32 %val_i2, i32* %dst_ptr_lo, align 4
  %i.next.lo = add i64 %i, 1
  %j.next.lo = add i64 %j, 0
  %k.next.lo = add i64 %k, 1
  br label %merge.body.done

take_right_only:
  %ptr_j2 = getelementptr inbounds i32, i32* %src.phi, i64 %j
  %val_j2 = load i32, i32* %ptr_j2, align 4
  %dst_ptr_ro = getelementptr inbounds i32, i32* %tmp.phi, i64 %k
  store i32 %val_j2, i32* %dst_ptr_ro, align 4
  %i.next.ro = add i64 %i, 0
  %j.next.ro = add i64 %j, 1
  %k.next.ro = add i64 %k, 1
  br label %merge.body.done

merge.body.done:
  %i.next = phi i64 [ %i.next.l, %take_left_both ], [ %i.next.r, %take_right ], [ %i.next.ro, %take_right_only ], [ %i.next.lo, %take_left_only ]
  %j.next = phi i64 [ %j.next.l, %take_left_both ], [ %j.next.r, %take_right ], [ %j.next.ro, %take_right_only ], [ %j.next.lo, %take_left_only ]
  %k.next = phi i64 [ %k.next.l, %take_left_both ], [ %k.next.r, %take_right ], [ %k.next.ro, %take_right_only ], [ %k.next.lo, %take_left_only ]
  br label %merge

merged:
  %start.next = add i64 %start, %tw
  br label %inner

after_inner:
  %width.next = shl i64 %width, 1
  %src.next = getelementptr inbounds i32, i32* %tmp.phi, i64 0
  %tmp.next = getelementptr inbounds i32, i32* %src.phi, i64 0
  br label %outer

after_outer:
  %cmp_src_arr = icmp eq i32* %src.phi, %arr
  br i1 %cmp_src_arr, label %free_block, label %do_copy

do_copy:
  %dest8 = bitcast i32* %arr to i8*
  %src8 = bitcast i32* %src.phi to i8*
  %callcpy = call i8* @memcpy(i8* %dest8, i8* %src8, i64 %size_bytes)
  br label %free_block

free_block:
  call void @free(i8* %tmp_raw)
  br label %return

return:
  ret void
}