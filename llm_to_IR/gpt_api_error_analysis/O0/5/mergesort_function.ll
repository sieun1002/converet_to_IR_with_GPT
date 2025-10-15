; ModuleID = 'merge_sort.ll'
target triple = "x86_64-pc-linux-gnu"

declare i8* @malloc(i64) nounwind
declare void @free(i8*) nounwind
declare i8* @memcpy(i8*, i8*, i64) nounwind

define void @merge_sort(i32* %dest, i64 %n) local_unnamed_addr {
entry:
  %cmp_n = icmp ule i64 %n, 1
  br i1 %cmp_n, label %ret, label %alloc

alloc:
  %size = shl i64 %n, 2
  %tmpraw = call i8* @malloc(i64 %size)
  %isnull = icmp eq i8* %tmpraw, null
  br i1 %isnull, label %ret, label %init

init:
  %tmpbuf = bitcast i8* %tmpraw to i32*
  br label %outer

outer:
  %src = phi i32* [ %dest, %init ], [ %src_next, %afterInner ]
  %buf = phi i32* [ %tmpbuf, %init ], [ %buf_next, %afterInner ]
  %run = phi i64 [ 1, %init ], [ %run_next, %afterInner ]
  %cond_outer = icmp ult i64 %run, %n
  br i1 %cond_outer, label %outer_body, label %outer_end

outer_body:
  %i = phi i64 [ 0, %outer ], [ %i_next, %outer_body_end ]
  %cond_i = icmp ult i64 %i, %n
  br i1 %cond_i, label %merge_prep, label %outer_body_done

merge_prep:
  %mid_pre = add i64 %i, %run
  %mid_lt_n = icmp ult i64 %mid_pre, %n
  %mid = select i1 %mid_lt_n, i64 %mid_pre, i64 %n
  %run_twice_prep = shl i64 %run, 1
  %right_pre = add i64 %i, %run_twice_prep
  %right_lt_n = icmp ult i64 %right_pre, %n
  %right = select i1 %right_lt_n, i64 %right_pre, i64 %n
  br label %merge_loop

merge_loop:
  %k = phi i64 [ %i, %merge_prep ], [ %k_next, %merge_next ]
  %l = phi i64 [ %i, %merge_prep ], [ %l_next_phi, %merge_next ]
  %r = phi i64 [ %mid, %merge_prep ], [ %r_next_phi, %merge_next ]
  %k_lt_right = icmp ult i64 %k, %right
  br i1 %k_lt_right, label %choose, label %after_merge

choose:
  %l_lt_mid = icmp ult i64 %l, %mid
  br i1 %l_lt_mid, label %check_right_avail, label %take_right_from_choose

check_right_avail:
  %r_lt_right = icmp ult i64 %r, %right
  br i1 %r_lt_right, label %cmp_values, label %take_left_from_check

cmp_values:
  %l_ptr_cmp = getelementptr inbounds i32, i32* %src, i64 %l
  %l_val_cmp = load i32, i32* %l_ptr_cmp, align 4
  %r_ptr_cmp = getelementptr inbounds i32, i32* %src, i64 %r
  %r_val_cmp = load i32, i32* %r_ptr_cmp, align 4
  %le_cmp = icmp sle i32 %l_val_cmp, %r_val_cmp
  br i1 %le_cmp, label %take_left_from_cmp, label %take_right_from_cmp

take_left_from_check:
  %l_ptr_store1 = getelementptr inbounds i32, i32* %src, i64 %l
  %l_val_store1 = load i32, i32* %l_ptr_store1, align 4
  %dst_ptr1 = getelementptr inbounds i32, i32* %buf, i64 %k
  store i32 %l_val_store1, i32* %dst_ptr1, align 4
  %l_inc1 = add i64 %l, 1
  %k_inc1 = add i64 %k, 1
  br label %merge_next

take_left_from_cmp:
  %l_ptr_store2 = getelementptr inbounds i32, i32* %src, i64 %l
  %l_val_store2 = load i32, i32* %l_ptr_store2, align 4
  %dst_ptr2 = getelementptr inbounds i32, i32* %buf, i64 %k
  store i32 %l_val_store2, i32* %dst_ptr2, align 4
  %l_inc2 = add i64 %l, 1
  %k_inc2 = add i64 %k, 1
  br label %merge_next

take_right_from_choose:
  %r_ptr_store1 = getelementptr inbounds i32, i32* %src, i64 %r
  %r_val_store1 = load i32, i32* %r_ptr_store1, align 4
  %dst_ptr3 = getelementptr inbounds i32, i32* %buf, i64 %k
  store i32 %r_val_store1, i32* %dst_ptr3, align 4
  %r_inc1 = add i64 %r, 1
  %k_inc3 = add i64 %k, 1
  br label %merge_next

take_right_from_cmp:
  %r_ptr_store2 = getelementptr inbounds i32, i32* %src, i64 %r
  %r_val_store2 = load i32, i32* %r_ptr_store2, align 4
  %dst_ptr4 = getelementptr inbounds i32, i32* %buf, i64 %k
  store i32 %r_val_store2, i32* %dst_ptr4, align 4
  %r_inc2 = add i64 %r, 1
  %k_inc4 = add i64 %k, 1
  br label %merge_next

merge_next:
  %l_next_phi = phi i64 [ %l_inc1, %take_left_from_check ], [ %l_inc2, %take_left_from_cmp ], [ %l, %take_right_from_choose ], [ %l, %take_right_from_cmp ]
  %r_next_phi = phi i64 [ %r, %take_left_from_check ], [ %r, %take_left_from_cmp ], [ %r_inc1, %take_right_from_choose ], [ %r_inc2, %take_right_from_cmp ]
  %k_next = phi i64 [ %k_inc1, %take_left_from_check ], [ %k_inc2, %take_left_from_cmp ], [ %k_inc3, %take_right_from_choose ], [ %k_inc4, %take_right_from_cmp ]
  br label %merge_loop

after_merge:
  br label %outer_body_end

outer_body_end:
  %run_twice = shl i64 %run, 1
  %i_next = add i64 %i, %run_twice
  br label %outer_body

outer_body_done:
  br label %afterInner

afterInner:
  %src_next = getelementptr inbounds i32, i32* %buf, i64 0
  %buf_next = getelementptr inbounds i32, i32* %src, i64 0
  %run_next = shl i64 %run, 1
  br label %outer

outer_end:
  %src_eq_dest = icmp eq i32* %src, %dest
  br i1 %src_eq_dest, label %free_and_ret, label %do_memcpy

do_memcpy:
  %dest_i8 = bitcast i32* %dest to i8*
  %src_i8 = bitcast i32* %src to i8*
  %memcpy_call = call i8* @memcpy(i8* %dest_i8, i8* %src_i8, i64 %size)
  br label %free_and_ret

free_and_ret:
  call void @free(i8* %tmpraw)
  br label %ret

ret:
  ret void
}