; LLVM IR for: merge_sort
; Assumed prototype: void merge_sort(int32_t* dest, uint64_t n)

declare noalias i8* @malloc(i64)
declare void @free(i8*)
declare i8* @memcpy(i8*, i8*, i64)

define void @merge_sort(i32* %dest, i64 %n) {
entry:
  %n_le_1 = icmp ule i64 %n, 1
  br i1 %n_le_1, label %ret, label %alloc

alloc:
  %bytes = shl i64 %n, 2
  %tmp_raw = call noalias i8* @malloc(i64 %bytes)
  %isnull = icmp eq i8* %tmp_raw, null
  br i1 %isnull, label %ret, label %init

init:
  %tmp0 = bitcast i8* %tmp_raw to i32*
  br label %outer.loop

outer.loop:
  %width = phi i64 [ 1, %init ], [ %width.next, %after.inner ]
  %src = phi i32* [ %dest, %init ], [ %src.next, %after.inner ]
  %tmp = phi i32* [ %tmp0, %init ], [ %tmp.next, %after.inner ]
  %cont.outer = icmp ult i64 %width, %n
  br i1 %cont.outer, label %inner.init, label %after.outer

inner.init:
  br label %inner.loop

inner.loop:
  %i = phi i64 [ 0, %inner.init ], [ %i.next, %after.merge ]
  %tw = shl i64 %width, 1
  %cont.inner = icmp ult i64 %i, %n
  br i1 %cont.inner, label %do.merge, label %after.inner

do.merge:
  %i_plus_w = add i64 %i, %width
  %mid.sel = icmp ule i64 %i_plus_w, %n
  %mid = select i1 %mid.sel, i64 %i_plus_w, i64 %n
  %i_plus_2w = add i64 %i, %tw
  %end.sel = icmp ule i64 %i_plus_2w, %n
  %end = select i1 %end.sel, i64 %i_plus_2w, i64 %n
  br label %merge.loop

merge.loop:
  %left = phi i64 [ %i, %do.merge ], [ %left.next, %choose.join ]
  %right = phi i64 [ %mid, %do.merge ], [ %right.next, %choose.join ]
  %k = phi i64 [ %i, %do.merge ], [ %k.next, %choose.join ]
  %k_lt_end = icmp ult i64 %k, %end
  br i1 %k_lt_end, label %choose, label %after.merge

choose:
  %left_lt_mid = icmp ult i64 %left, %mid
  br i1 %left_lt_mid, label %check.right, label %take.right

check.right:
  %right_lt_end = icmp ult i64 %right, %end
  br i1 %right_lt_end, label %compare, label %take.left

compare:
  %lptr.c = getelementptr inbounds i32, i32* %src, i64 %left
  %lval.c = load i32, i32* %lptr.c, align 4
  %rptr.c = getelementptr inbounds i32, i32* %src, i64 %right
  %rval.c = load i32, i32* %rptr.c, align 4
  %l_gt_r = icmp sgt i32 %lval.c, %rval.c
  br i1 %l_gt_r, label %take.right, label %take.left

take.left:
  %lptr = getelementptr inbounds i32, i32* %src, i64 %left
  %lval = load i32, i32* %lptr, align 4
  %dptrL = getelementptr inbounds i32, i32* %tmp, i64 %k
  store i32 %lval, i32* %dptrL, align 4
  %left.next = add i64 %left, 1
  %right.next = %right
  %k.next = add i64 %k, 1
  br label %choose.join

take.right:
  %rptr = getelementptr inbounds i32, i32* %src, i64 %right
  %rval = load i32, i32* %rptr, align 4
  %dptrR = getelementptr inbounds i32, i32* %tmp, i64 %k
  store i32 %rval, i32* %dptrR, align 4
  %right.next = add i64 %right, 1
  %left.next = %left
  %k.next = add i64 %k, 1
  br label %choose.join

choose.join:
  br label %merge.loop

after.merge:
  %i.next = add i64 %i, %tw
  br label %inner.loop

after.inner:
  %src.next = %tmp
  %tmp.next = %src
  %width.next = shl i64 %width, 1
  br label %outer.loop

after.outer:
  %src.final = %src
  %need.copy = icmp eq i32* %src.final, %dest
  br i1 %need.copy, label %do.free, label %do.memcpy

do.memcpy:
  %bytes2 = shl i64 %n, 2
  %d8 = bitcast i32* %dest to i8*
  %s8 = bitcast i32* %src.final to i8*
  %_ = call i8* @memcpy(i8* %d8, i8* %s8, i64 %bytes2)
  br label %do.free

do.free:
  call void @free(i8* %tmp_raw)
  br label %ret

ret:
  ret void
}