; ModuleID = 'merge_sort.ll'
source_filename = "merge_sort"

declare noalias i8* @malloc(i64)
declare void @free(i8*)
declare i8* @memcpy(i8*, i8*, i64)

define dso_local void @merge_sort(i32* %dest, i64 %n) {
entry:
  %cmp_le1 = icmp ule i64 %n, 1
  br i1 %cmp_le1, label %ret, label %alloc

alloc:
  %size = shl i64 %n, 2
  %buf_i8 = call i8* @malloc(i64 %size)
  %isnull = icmp eq i8* %buf_i8, null
  br i1 %isnull, label %ret, label %init

init:
  %buf = bitcast i8* %buf_i8 to i32*
  br label %outer

outer:
  %run = phi i64 [ 1, %init ], [ %run2, %swapdone ]
  %src = phi i32* [ %dest, %init ], [ %src2, %swapdone ]
  %dst = phi i32* [ %buf, %init ], [ %dst2, %swapdone ]
  %cond_outer = icmp ult i64 %run, %n
  br i1 %cond_outer, label %inner_init, label %done_outer

inner_init:
  %i = phi i64 [ 0, %outer ], [ %i_next, %inner_done ]
  %cond_inner = icmp ult i64 %i, %n
  br i1 %cond_inner, label %merge_prep, label %swap

merge_prep:
  %left = %i
  %tmp_add = add i64 %i, %run
  %lt1 = icmp ult i64 %tmp_add, %n
  %left_end = select i1 %lt1, i64 %tmp_add, i64 %n
  %right = %left_end
  %two_run = shl i64 %run, 1
  %tmp_add2 = add i64 %i, %two_run
  %lt2 = icmp ult i64 %tmp_add2, %n
  %right_end = select i1 %lt2, i64 %tmp_add2, i64 %n
  %k = %i
  br label %merge_loop

merge_loop:
  %kphi = phi i64 [ %k, %merge_prep ], [ %k_next, %after_write ], [ %k_next_r, %after_write_r ]
  %lphi = phi i64 [ %left, %merge_prep ], [ %l_next, %after_write ], [ %l_same_r, %after_write_r ]
  %rphi = phi i64 [ %right, %merge_prep ], [ %r_same, %after_write ], [ %r_next_r, %after_write_r ]
  %cond_k = icmp ult i64 %kphi, %right_end
  br i1 %cond_k, label %choose, label %after_merge

choose:
  %l_in = icmp ult i64 %lphi, %left_end
  br i1 %l_in, label %check_right_in, label %take_right

check_right_in:
  %r_in = icmp ult i64 %rphi, %right_end
  br i1 %r_in, label %compare_vals, label %take_left

compare_vals:
  %lptr = getelementptr inbounds i32, i32* %src, i64 %lphi
  %lval = load i32, i32* %lptr, align 4
  %rptr = getelementptr inbounds i32, i32* %src, i64 %rphi
  %rval = load i32, i32* %rptr, align 4
  %cmp = icmp sgt i32 %lval, %rval
  br i1 %cmp, label %take_right_with_vals, label %take_left_with_vals

take_left_with_vals:
  %dst_k_ptr = getelementptr inbounds i32, i32* %dst, i64 %kphi
  store i32 %lval, i32* %dst_k_ptr, align 4
  %k_next1 = add i64 %kphi, 1
  %l_next1 = add i64 %lphi, 1
  br label %after_write

take_right_with_vals:
  %dst_k_ptr2 = getelementptr inbounds i32, i32* %dst, i64 %kphi
  store i32 %rval, i32* %dst_k_ptr2, align 4
  %k_next2 = add i64 %kphi, 1
  %r_next2 = add i64 %rphi, 1
  br label %after_write_r

take_left:
  %lptr2 = getelementptr inbounds i32, i32* %src, i64 %lphi
  %lval2 = load i32, i32* %lptr2, align 4
  %dst_k_ptr3 = getelementptr inbounds i32, i32* %dst, i64 %kphi
  store i32 %lval2, i32* %dst_k_ptr3, align 4
  %k_next3 = add i64 %kphi, 1
  %l_next3 = add i64 %lphi, 1
  br label %after_write

take_right:
  %rptr2 = getelementptr inbounds i32, i32* %src, i64 %rphi
  %rval2 = load i32, i32* %rptr2, align 4
  %dst_k_ptr4 = getelementptr inbounds i32, i32* %dst, i64 %kphi
  store i32 %rval2, i32* %dst_k_ptr4, align 4
  %k_next4 = add i64 %kphi, 1
  %r_next4 = add i64 %rphi, 1
  br label %after_write_r

after_write:
  %k_next = phi i64 [ %k_next1, %take_left_with_vals ], [ %k_next3, %take_left ]
  %l_next = phi i64 [ %l_next1, %take_left_with_vals ], [ %l_next3, %take_left ]
  %r_same = phi i64 [ %rphi, %take_left_with_vals ], [ %rphi, %take_left ]
  br label %merge_loop

after_write_r:
  %k_next_r = phi i64 [ %k_next2, %take_right_with_vals ], [ %k_next4, %take_right ]
  %l_same_r = phi i64 [ %lphi, %take_right_with_vals ], [ %lphi, %take_right ]
  %r_next_r = phi i64 [ %r_next2, %take_right_with_vals ], [ %r_next4, %take_right ]
  br label %merge_loop

after_merge:
  %i_next = add i64 %i, %two_run
  br label %inner_done

inner_done:
  br label %inner_init

swap:
  %src2 = %dst
  %dst2 = %src
  %run2 = shl i64 %run, 1
  br label %swapdone

swapdone:
  br label %outer

done_outer:
  %src_final = phi i32* [ %src, %outer ]
  %cmp_src_dest = icmp eq i32* %src_final, %dest
  br i1 %cmp_src_dest, label %free_only, label %do_copy

do_copy:
  %dest_i8 = bitcast i32* %dest to i8*
  %src_i8 = bitcast i32* %src_final to i8*
  %size2 = shl i64 %n, 2
  %call_memcpy = call i8* @memcpy(i8* %dest_i8, i8* %src_i8, i64 %size2)
  br label %free_only

free_only:
  call void @free(i8* %buf_i8)
  br label %ret

ret:
  ret void
}