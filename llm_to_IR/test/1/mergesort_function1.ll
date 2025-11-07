; ModuleID = 'merge_sort'
target triple = "x86_64-unknown-linux-gnu"

declare noalias i8* @malloc(i64 noundef)
declare void @free(i8* noundef)
declare i8* @memcpy(i8* noundef, i8* noundef, i64 noundef)

define void @merge_sort(i32* noundef %dest, i64 noundef %n) local_unnamed_addr {
entry:
  %n_le1 = icmp ule i64 %n, 1
  br i1 %n_le1, label %ret, label %alloc

alloc:
  %bytes = shl i64 %n, 2
  %buf_i8 = call noalias i8* @malloc(i64 %bytes)
  %buf = bitcast i8* %buf_i8 to i32*
  %buf_null = icmp eq i32* %buf, null
  br i1 %buf_null, label %ret, label %init

init:
  br label %outer_cond

outer_cond:
  %width = phi i64 [ 1, %init ], [ %width_next, %outer_post ]
  %src = phi i32* [ %dest, %init ], [ %src_swapped, %outer_post ]
  %dst = phi i32* [ %buf, %init ], [ %dst_swapped, %outer_post ]
  %width_lt_n = icmp ult i64 %width, %n
  br i1 %width_lt_n, label %inner_init, label %outer_done

inner_init:
  %i = phi i64 [ 0, %outer_cond ], [ %i_next, %inner_post ]
  %i_lt_n = icmp ult i64 %i, %n
  br i1 %i_lt_n, label %merge_prep, label %inner_done

merge_prep:
  %mid_tmp = add i64 %i, %width
  %mid_ok = icmp ule i64 %mid_tmp, %n
  %mid = select i1 %mid_ok, i64 %mid_tmp, i64 %n
  %tw = shl i64 %width, 1
  %right_tmp = add i64 %i, %tw
  %right_ok = icmp ule i64 %right_tmp, %n
  %right = select i1 %right_ok, i64 %right_tmp, i64 %n
  br label %merge_cond

merge_cond:
  %li = phi i64 [ %i, %merge_prep ], [ %li_next, %merge_body_end ]
  %ri = phi i64 [ %mid, %merge_prep ], [ %ri_next, %merge_body_end ]
  %di = phi i64 [ %i, %merge_prep ], [ %di_next, %merge_body_end ]
  %di_lt_right = icmp ult i64 %di, %right
  br i1 %di_lt_right, label %merge_body, label %merge_done

merge_body:
  %li_lt_mid = icmp ult i64 %li, %mid
  br i1 %li_lt_mid, label %check_ri, label %take_right

check_ri:
  %ri_lt_right = icmp ult i64 %ri, %right
  br i1 %ri_lt_right, label %cmp_vals, label %take_left

cmp_vals:
  %li_ptr = getelementptr inbounds i32, i32* %src, i64 %li
  %lv = load i32, i32* %li_ptr, align 4
  %ri_ptr = getelementptr inbounds i32, i32* %src, i64 %ri
  %rv = load i32, i32* %ri_ptr, align 4
  %l_gt_r = icmp sgt i32 %lv, %rv
  br i1 %l_gt_r, label %take_right, label %take_left

take_left:
  %li_ptr2 = getelementptr inbounds i32, i32* %src, i64 %li
  %lv2 = load i32, i32* %li_ptr2, align 4
  %dst_ptrL = getelementptr inbounds i32, i32* %dst, i64 %di
  store i32 %lv2, i32* %dst_ptrL, align 4
  %li_inc = add i64 %li, 1
  %di_inc = add i64 %di, 1
  br label %merge_body_end

take_right:
  %ri_ptr2 = getelementptr inbounds i32, i32* %src, i64 %ri
  %rv2 = load i32, i32* %ri_ptr2, align 4
  %dst_ptrR = getelementptr inbounds i32, i32* %dst, i64 %di
  store i32 %rv2, i32* %dst_ptrR, align 4
  %ri_inc = add i64 %ri, 1
  %di_inc2 = add i64 %di, 1
  br label %merge_body_end

merge_body_end:
  %li_next = phi i64 [ %li_inc, %take_left ], [ %li, %take_right ]
  %ri_next = phi i64 [ %ri, %take_left ], [ %ri_inc, %take_right ]
  %di_next = phi i64 [ %di_inc, %take_left ], [ %di_inc2, %take_right ]
  br label %merge_cond

merge_done:
  %i_next = add i64 %i, %tw
  br label %inner_post

inner_post:
  br label %inner_init

inner_done:
  %src_swapped = phi i32* [ %dst, %inner_init ]
  %dst_swapped = phi i32* [ %src, %inner_init ]
  %width_next = shl i64 %width, 1
  br label %outer_post

outer_post:
  br label %outer_cond

outer_done:
  %src_final = phi i32* [ %src, %outer_cond ]
  %src_eq_dest = icmp eq i32* %src_final, %dest
  br i1 %src_eq_dest, label %free_block, label %do_memcpy

do_memcpy:
  %bytes2 = shl i64 %n, 2
  %dest_i8 = bitcast i32* %dest to i8*
  %src_i8 = bitcast i32* %src_final to i8*
  %memcpy_res = call i8* @memcpy(i8* %dest_i8, i8* %src_i8, i64 %bytes2)
  br label %free_block

free_block:
  %buf_i8_to_free = bitcast i32* %buf to i8*
  call void @free(i8* %buf_i8_to_free)
  br label %ret

ret:
  ret void
}