; ModuleID = 'merge_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: merge_sort  ; Address: 0x11E9
; Intent: Stable ascending merge sort (bottom-up) on i32 array in-place with temp buffer (confidence=0.98). Evidence: iterative width doubling, stable merge using signed compare with fallback to left on ties.
; Preconditions: dest points to at least n i32 elements; if n > 0, dest is non-null.
; Postconditions: dest[0..n) is sorted in ascending (signed) order; stability preserved.

declare noalias i8* @malloc(i64) local_unnamed_addr
declare void @free(i8*) local_unnamed_addr
declare i8* @memcpy(i8*, i8*, i64) local_unnamed_addr

define dso_local void @merge_sort(i32* %dest, i64 %n) local_unnamed_addr {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %ret, label %alloc

alloc:
  %size.bytes = shl i64 %n, 2
  %buf.raw = call i8* @malloc(i64 %size.bytes)
  %isnull = icmp eq i8* %buf.raw, null
  br i1 %isnull, label %ret, label %init

init:
  %buf.i32 = bitcast i8* %buf.raw to i32*
  br label %outer_check

outer_check:
  %src.phi = phi i32* [ %dest, %init ], [ %src.next, %after_inner ]
  %tmp.phi = phi i32* [ %buf.i32, %init ], [ %tmp.next, %after_inner ]
  %width.phi = phi i64 [ 1, %init ], [ %width.next, %after_inner ]
  %cont = icmp ult i64 %width.phi, %n
  br i1 %cont, label %outer_body_init, label %after_all

outer_body_init:
  br label %inner_check

inner_check:
  %i.phi = phi i64 [ 0, %outer_body_init ], [ %i.next, %after_run ]
  %more = icmp ult i64 %i.phi, %n
  br i1 %more, label %process_run, label %after_inner

process_run:
  %i.cur = add i64 %i.phi, 0
  %left = %i.cur
  %i_plus_w = add i64 %i.cur, %width.phi
  %mid = call i64 @llvm.umin.i64(i64 %i_plus_w, i64 %n)
  %i_plus_2w = add i64 %i.cur, %width.phi
  %i_plus_2w2 = add i64 %i_plus_2w, %width.phi
  %right.end = call i64 @llvm.umin.i64(i64 %i_plus_2w2, i64 %n)
  br label %merge_check

merge_check:
  %lcur = phi i64 [ %left, %process_run ], [ %lcur.next, %take_left ], [ %lcur, %take_right ]
  %rcur = phi i64 [ %mid, %process_run ], [ %rcur, %take_left ], [ %rcur.next, %take_right ]
  %kcur = phi i64 [ %i.cur, %process_run ], [ %k.next.L, %take_left ], [ %k.next.R, %take_right ]
  %klt = icmp ult i64 %kcur, %right.end
  br i1 %klt, label %merge_decide_left_has, label %after_run

merge_decide_left_has:
  %l_has = icmp ult i64 %lcur, %mid
  br i1 %l_has, label %merge_decide_right_has, label %choose_right_no_left

merge_decide_right_has:
  %r_has = icmp ult i64 %rcur, %right.end
  br i1 %r_has, label %both_have, label %choose_left_no_right

both_have:
  %l.addr = getelementptr inbounds i32, i32* %src.phi, i64 %lcur
  %l.val = load i32, i32* %l.addr, align 4
  %r.addr = getelementptr inbounds i32, i32* %src.phi, i64 %rcur
  %r.val = load i32, i32* %r.addr, align 4
  %l_gt_r = icmp sgt i32 %l.val, %r.val
  br i1 %l_gt_r, label %take_right, label %take_left

choose_left_no_right:
  br label %take_left

choose_right_no_left:
  br label %take_right

take_left:
  %out.addr.L = getelementptr inbounds i32, i32* %tmp.phi, i64 %kcur
  store i32 %l.val, i32* %out.addr.L, align 4
  %k.next.L = add i64 %kcur, 1
  %lcur.next = add i64 %lcur, 1
  br label %merge_check

take_right:
  %out.addr.R = getelementptr inbounds i32, i32* %tmp.phi, i64 %kcur
  store i32 %r.val, i32* %out.addr.R, align 4
  %k.next.R = add i64 %kcur, 1
  %rcur.next = add i64 %rcur, 1
  br label %merge_check

after_run:
  %two.w = shl i64 %width.phi, 1
  %i.next = add i64 %i.phi, %two.w
  br label %inner_check

after_inner:
  %src.next = %tmp.phi
  %tmp.next = %src.phi
  %width.next = shl i64 %width.phi, 1
  br label %outer_check

after_all:
  %need_copy = icmp ne i32* %src.phi, %dest
  br i1 %need_copy, label %do_memcpy, label %after_copy

do_memcpy:
  %dest.i8 = bitcast i32* %dest to i8*
  %src.i8 = bitcast i32* %src.phi to i8*
  %_ = call i8* @memcpy(i8* %dest.i8, i8* %src.i8, i64 %size.bytes)
  br label %after_copy

after_copy:
  call void @free(i8* %buf.raw)
  br label %ret

ret:
  ret void
}

declare i64 @llvm.umin.i64(i64, i64) nounwind readnone llvm_intrinsic