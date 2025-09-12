; LLVM 14 IR for function: merge_sort

declare i8* @malloc(i64)
declare void @free(i8*)
declare i8* @memcpy(i8*, i8*, i64)

define void @merge_sort(i32* %dest, i64 %n) {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %ret, label %alloc

alloc:
  %size = shl i64 %n, 2
  %raw = call i8* @malloc(i64 %size)
  %isnull = icmp eq i8* %raw, null
  br i1 %isnull, label %ret, label %init

init:
  %tmp0 = bitcast i8* %raw to i32*
  br label %outer

outer:
  %width = phi i64 [ 1, %init ], [ %width.next, %swapdone ]
  %srcptr = phi i32* [ %dest, %init ], [ %src.next, %swapdone ]
  %tmpptr = phi i32* [ %tmp0, %init ], [ %tmp.next, %swapdone ]
  %cond_width = icmp ult i64 %width, %n
  br i1 %cond_width, label %inner.init, label %outer.done

inner.init:
  %i = phi i64 [ 0, %outer ], [ %i.next, %inner.after.merge ]
  %cond_i = icmp ult i64 %i, %n
  br i1 %cond_i, label %setup, label %after.inner

setup:
  %left0 = add i64 %i, 0
  %i_plus_w = add i64 %i, %width
  %i_plus_w_lt_n = icmp ult i64 %i_plus_w, %n
  %mid = select i1 %i_plus_w_lt_n, i64 %i_plus_w, i64 %n
  %right0 = add i64 %i, %width
  %i_plus_2w = add i64 %i, %width
  %i_plus_2w2 = add i64 %i_plus_2w, %width
  %i_plus_2w2_lt_n = icmp ult i64 %i_plus_2w2, %n
  %rightend = select i1 %i_plus_2w2_lt_n, i64 %i_plus_2w2, i64 %n
  %k0 = add i64 %i, 0
  br label %merge.loop

merge.loop:
  %left = phi i64 [ %left0, %setup ], [ %left.next, %merge.iter.done ]
  %right = phi i64 [ %right0, %setup ], [ %right.next, %merge.iter.done ]
  %k = phi i64 [ %k0, %setup ], [ %k.next, %merge.iter.done ]
  %condk = icmp ult i64 %k, %rightend
  br i1 %condk, label %choose, label %inner.after.merge

choose:
  %left_ok = icmp ult i64 %left, %mid
  %right_ok = icmp ult i64 %right, %rightend
  br i1 %left_ok, label %check_right, label %take_right

check_right:
  br i1 %right_ok, label %cmpvals, label %take_left

cmpvals:
  %left.ptr = getelementptr inbounds i32, i32* %srcptr, i64 %left
  %left.val = load i32, i32* %left.ptr, align 4
  %right.ptr = getelementptr inbounds i32, i32* %srcptr, i64 %right
  %right.val = load i32, i32* %right.ptr, align 4
  %left_gt_right = icmp sgt i32 %left.val, %right.val
  br i1 %left_gt_right, label %take_right, label %take_left

take_left:
  %srcL.ptr = getelementptr inbounds i32, i32* %srcptr, i64 %left
  %valL = load i32, i32* %srcL.ptr, align 4
  %dst.ptr = getelementptr inbounds i32, i32* %tmpptr, i64 %k
  store i32 %valL, i32* %dst.ptr, align 4
  %left.next = add i64 %left, 1
  %right.next = add i64 %right, 0
  %k.next = add i64 %k, 1
  br label %merge.iter.done

take_right:
  %srcR.ptr = getelementptr inbounds i32, i32* %srcptr, i64 %right
  %valR = load i32, i32* %srcR.ptr, align 4
  %dst.ptr2 = getelementptr inbounds i32, i32* %tmpptr, i64 %k
  store i32 %valR, i32* %dst.ptr2, align 4
  %right.next = add i64 %right, 1
  %left.next = add i64 %left, 0
  %k.next = add i64 %k, 1
  br label %merge.iter.done

merge.iter.done:
  br label %merge.loop

inner.after.merge:
  %tw = add i64 %width, %width
  %i.next = add i64 %i, %tw
  br label %inner.init

after.inner:
  %src.next = %tmpptr
  %tmp.next = %srcptr
  %width.next = shl i64 %width, 1
  br label %swapdone

swapdone:
  br label %outer

outer.done:
  %cmpSrcDest = icmp eq i32* %srcptr, %dest
  br i1 %cmpSrcDest, label %free, label %docopy

docopy:
  %dest8 = bitcast i32* %dest to i8*
  %src8 = bitcast i32* %srcptr to i8*
  call i8* @memcpy(i8* %dest8, i8* %src8, i64 %size)
  br label %free

free:
  call void @free(i8* %raw)
  br label %ret

ret:
  ret void
}