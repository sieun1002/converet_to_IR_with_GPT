; ModuleID = 'merge_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: merge_sort ; Address: 0x11E9
; Intent: Bottom-up merge sort int32 array in ascending order (confidence=0.98). Evidence: malloc(n*4), iterative width doubling, signed compare jg, final memcpy/free.
; Preconditions: dest may be null only if n==0; n is the element count (0..2^64-1).
; Postconditions: If malloc succeeds: dest[0..n) sorted ascending.

; Only the necessary external declarations:
declare noalias i8* @_malloc(i64)
declare void @_free(i8*)
declare i8* @_memcpy(i8* nocapture, i8* nocapture, i64)

define dso_local void @merge_sort(i32* %dest, i64 %n) local_unnamed_addr {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %ret, label %alloc

alloc:
  %size.bytes = shl i64 %n, 2
  %buf.i8 = call i8* @_malloc(i64 %size.bytes)
  %isnull = icmp eq i8* %buf.i8, null
  br i1 %isnull, label %ret, label %cont

cont:
  %buf = bitcast i8* %buf.i8 to i32*
  br label %outer

outer:
  %src.phi = phi i32* [ %dest, %cont ], [ %tmp.next, %pass_done ]
  %tmp.phi = phi i32* [ %buf, %cont ], [ %src.next, %pass_done ]
  %width.phi = phi i64 [ 1, %cont ], [ %width.next, %pass_done ]
  %cond.outer = icmp ult i64 %width.phi, %n
  br i1 %cond.outer, label %pass, label %after_loops

pass:
  %twoW = shl i64 %width.phi, 1
  br label %loop_i

loop_i:
  %i = phi i64 [ 0, %pass ], [ %i.next, %after_inner ]
  %cond_i = icmp ult i64 %i, %n
  br i1 %cond_i, label %merge_setup, label %pass_done

merge_setup:
  %left = %i
  %i_plus_w = add i64 %i, %width.phi
  %mid.cond = icmp ule i64 %i_plus_w, %n
  %mid = select i1 %mid.cond, i64 %i_plus_w, i64 %n
  %i_plus_2w = add i64 %i, %twoW
  %end.cond = icmp ule i64 %i_plus_2w, %n
  %end = select i1 %end.cond, i64 %i_plus_2w, i64 %n
  %l.init = %left
  %r.init = %mid
  %k.init = %left
  br label %inner

inner:
  %l = phi i64 [ %l.init, %merge_setup ], [ %l.next, %inner.latch ]
  %r = phi i64 [ %r.init, %merge_setup ], [ %r.next, %inner.latch ]
  %k = phi i64 [ %k.init, %merge_setup ], [ %k.next, %inner.latch ]
  %k_lt_end = icmp ult i64 %k, %end
  br i1 %k_lt_end, label %choose_left_cond, label %after_inner

choose_left_cond:
  %l_lt_mid = icmp ult i64 %l, %mid
  br i1 %l_lt_mid, label %check_r, label %take_right

check_r:
  %r_lt_end = icmp ult i64 %r, %end
  br i1 %r_lt_end, label %compare_vals, label %take_left

compare_vals:
  %lptr = getelementptr inbounds i32, i32* %src.phi, i64 %l
  %lval = load i32, i32* %lptr, align 4
  %rptr = getelementptr inbounds i32, i32* %src.phi, i64 %r
  %rval = load i32, i32* %rptr, align 4
  %is_l_gt_r = icmp sgt i32 %lval, %rval
  br i1 %is_l_gt_r, label %take_right, label %take_left

take_left:
  %lptr.store = getelementptr inbounds i32, i32* %src.phi, i64 %l
  %lval.store = load i32, i32* %lptr.store, align 4
  %tptrL = getelementptr inbounds i32, i32* %tmp.phi, i64 %k
  store i32 %lval.store, i32* %tptrL, align 4
  %l.next = add i64 %l, 1
  %r.next.l = %r
  %k.next.l = add i64 %k, 1
  br label %inner.latch

take_right:
  %rptr.store = getelementptr inbounds i32, i32* %src.phi, i64 %r
  %rval.store = load i32, i32* %rptr.store, align 4
  %tptrR = getelementptr inbounds i32, i32* %tmp.phi, i64 %k
  store i32 %rval.store, i32* %tptrR, align 4
  %r.next = add i64 %r, 1
  %l.next.r = %l
  %k.next.r = add i64 %k, 1
  br label %inner.latch

inner.latch:
  %l.next = phi i64 [ %l.next, %take_left ], [ %l.next.r, %take_right ]
  %r.next = phi i64 [ %r.next.l, %take_left ], [ %r.next, %take_right ]
  %k.next = phi i64 [ %k.next.l, %take_left ], [ %k.next.r, %take_right ]
  br label %inner

after_inner:
  %i.next = add i64 %i, %twoW
  br label %loop_i

pass_done:
  %src.next = %tmp.phi
  %tmp.next = %src.phi
  %width.next = shl i64 %width.phi, 1
  br label %outer

after_loops:
  %src.out = phi i32* [ %src.phi, %outer ]
  %same = icmp eq i32* %src.out, %dest
  br i1 %same, label %do_free, label %do_copy

do_copy:
  %dest.i8 = bitcast i32* %dest to i8*
  %src.i8 = bitcast i32* %src.out to i8*
  %size.bytes.copy = shl i64 %n, 2
  %_ = call i8* @_memcpy(i8* %dest.i8, i8* %src.i8, i64 %size.bytes.copy)
  br label %do_free

do_free:
  call void @_free(i8* %buf.i8)
  br label %ret

ret:
  ret void
}