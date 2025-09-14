; ModuleID = 'merge_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: merge_sort  ; Address: 0x11E9
; Intent: Bottom-up merge sort of 32-bit signed integers in-place using O(n) temp buffer (confidence=0.92). Evidence: malloc of n*4, bottom-up merging loops, final memcpy back to dest.
; Preconditions: dest points to at least n 32-bit elements; n is a non-negative 64-bit length.
; Postconditions: If allocation succeeds, dest is sorted ascending (signed). If malloc fails, dest is left unchanged.

; Only the needed extern declarations:
declare noalias i8* @malloc(i64) local_unnamed_addr
declare i8* @memcpy(i8*, i8*, i64) local_unnamed_addr
declare void @free(i8*) local_unnamed_addr

define dso_local void @merge_sort(i32* %dest, i64 %n) local_unnamed_addr {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %ret, label %alloc

alloc:
  %size = shl i64 %n, 2
  %tmpraw = call noalias i8* @malloc(i64 %size)
  %isnull = icmp eq i8* %tmpraw, null
  br i1 %isnull, label %ret, label %init

init:
  %tmp = bitcast i8* %tmpraw to i32*
  br label %outer_head

outer_head:
  %width = phi i64 [ 1, %init ], [ %width_next, %after_inner ]
  %src = phi i32* [ %dest, %init ], [ %src2, %after_inner ]
  %buf = phi i32* [ %tmp, %init ], [ %buf2, %after_inner ]
  %cond_outer = icmp ult i64 %width, %n
  br i1 %cond_outer, label %inner_init, label %after_passes

inner_init:
  %i = phi i64 [ 0, %outer_head ], [ %i_next, %after_merge ]
  %i_cond = icmp ult i64 %i, %n
  br i1 %i_cond, label %setup_merge, label %after_inner

setup_merge:
  %left = %i
  %t1 = add i64 %i, %width
  %mid_lt = icmp ult i64 %t1, %n
  %mid = select i1 %mid_lt, i64 %t1, i64 %n
  %tw = add i64 %width, %width
  %t3 = add i64 %i, %tw
  %end_lt = icmp ult i64 %t3, %n
  %end = select i1 %end_lt, i64 %t3, i64 %n
  br label %merge_head

merge_head:
  %l = phi i64 [ %left, %setup_merge ], [ %l_next, %after_take ]
  %r = phi i64 [ %mid, %setup_merge ], [ %r_next, %after_take ]
  %k = phi i64 [ %i, %setup_merge ], [ %k_next, %after_take ]
  %k_lt_end = icmp ult i64 %k, %end
  br i1 %k_lt_end, label %choose_left_check, label %after_merge

choose_left_check:
  %l_lt_mid = icmp ult i64 %l, %mid
  br i1 %l_lt_mid, label %check_r, label %take_right

check_r:
  %r_lt_end = icmp ult i64 %r, %end
  br i1 %r_lt_end, label %compare_vals, label %take_left

compare_vals:
  %lptr = getelementptr inbounds i32, i32* %src, i64 %l
  %lval = load i32, i32* %lptr, align 4
  %rptr = getelementptr inbounds i32, i32* %src, i64 %r
  %rval = load i32, i32* %rptr, align 4
  %l_gt_r = icmp sgt i32 %lval, %rval
  br i1 %l_gt_r, label %take_right, label %take_left

take_left:
  %lptr2 = getelementptr inbounds i32, i32* %src, i64 %l
  %lval2 = load i32, i32* %lptr2, align 4
  %bufkptr = getelementptr inbounds i32, i32* %buf, i64 %k
  store i32 %lval2, i32* %bufkptr, align 4
  %l_next_l = add i64 %l, 1
  %r_next_l = %r
  %k_next_l = add i64 %k, 1
  br label %after_take

take_right:
  %rptr2 = getelementptr inbounds i32, i32* %src, i64 %r
  %rval2 = load i32, i32* %rptr2, align 4
  %bufkptr2 = getelementptr inbounds i32, i32* %buf, i64 %k
  store i32 %rval2, i32* %bufkptr2, align 4
  %l_next_r = %l
  %r_next_r = add i64 %r, 1
  %k_next_r = add i64 %k, 1
  br label %after_take

after_take:
  %l_next = phi i64 [ %l_next_l, %take_left ], [ %l_next_r, %take_right ]
  %r_next = phi i64 [ %r_next_l, %take_left ], [ %r_next_r, %take_right ]
  %k_next = phi i64 [ %k_next_l, %take_left ], [ %k_next_r, %take_right ]
  br label %merge_head

after_merge:
  %tw2 = add i64 %width, %width
  %i_next = add i64 %i, %tw2
  br label %inner_init

after_inner:
  %src2 = %buf
  %buf2 = %src
  %width_next = shl i64 %width, 1
  br label %outer_head

after_passes:
  %src_ne_dest = icmp ne i32* %src, i32* %dest
  br i1 %src_ne_dest, label %do_memcpy, label %after_copy

do_memcpy:
  %dest_i8 = bitcast i32* %dest to i8*
  %src_i8 = bitcast i32* %src to i8*
  %call_memcpy = call i8* @memcpy(i8* %dest_i8, i8* %src_i8, i64 %size)
  br label %after_copy

after_copy:
  call void @free(i8* %tmpraw)
  br label %ret

ret:
  ret void
}