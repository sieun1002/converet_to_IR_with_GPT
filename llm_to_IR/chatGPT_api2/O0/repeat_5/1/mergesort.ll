; ModuleID = 'merge_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: merge_sort  ; Address: 0x11E9
; Intent: Stable bottom-up merge sort of 32-bit signed integers in ascending order (confidence=0.95). Evidence: allocate n*4 temp buffer; iterative merge passes with run width doubling; final memcpy back if needed.
; Preconditions: dest points to at least n elements of i32; n is a non-negative element count (treated as unsigned for bounds).
; Postconditions: dest is sorted in nondecreasing order w.r.t. signed 32-bit comparison; no effect if n <= 1 or allocation fails.

; Only the needed extern declarations:
declare noalias i8* @malloc(i64)
declare void @free(i8*)
declare i8* @memcpy(i8*, i8*, i64)

define dso_local void @merge_sort(i32* %dest, i64 %n) local_unnamed_addr {
entry:
  %cmp.n.le1 = icmp ule i64 %n, 1
  br i1 %cmp.n.le1, label %ret, label %alloc

alloc:
  %size = shl i64 %n, 2
  %tmp8 = call noalias i8* @malloc(i64 %size)
  %isnull = icmp eq i8* %tmp8, null
  br i1 %isnull, label %ret, label %init

init:
  %tmpi32 = bitcast i8* %tmp8 to i32*
  br label %outer.cond

outer.cond:
  %width = phi i64 [ 1, %init ], [ %width.next, %outer.swap ]
  %src = phi i32* [ %dest, %init ], [ %src.next, %outer.swap ]
  %buf = phi i32* [ %tmpi32, %init ], [ %buf.next, %outer.swap ]
  %cond = icmp ult i64 %width, %n
  br i1 %cond, label %outer.body.entry, label %after.outer

outer.body.entry:
  br label %inner.cond

inner.cond:
  %base = phi i64 [ 0, %outer.body.entry ], [ %base.next, %inner.after.merge ]
  %base_cmp = icmp ult i64 %base, %n
  br i1 %base_cmp, label %merge.init, label %outer.swap

merge.init:
  %mid.tmp = add i64 %base, %width
  %mid.cmp = icmp ule i64 %mid.tmp, %n
  %mid = select i1 %mid.cmp, i64 %mid.tmp, i64 %n
  %twoW = shl i64 %width, 1
  %end.tmp = add i64 %base, %twoW
  %end.cmp = icmp ule i64 %end.tmp, %n
  %end = select i1 %end.cmp, i64 %end.tmp, i64 %n
  br label %merge.loop.cond

merge.loop.cond:
  %k = phi i64 [ %base, %merge.init ], [ %k.next, %merge.write ]
  %i = phi i64 [ %base, %merge.init ], [ %i.next, %merge.write ]
  %j = phi i64 [ %mid, %merge.init ], [ %j.next, %merge.write ]
  %k_lt_end = icmp ult i64 %k, %end
  br i1 %k_lt_end, label %choose.leftcheck, label %inner.after.merge

choose.leftcheck:
  %i_lt_mid = icmp ult i64 %i, %mid
  br i1 %i_lt_mid, label %check.right, label %use.right

check.right:
  %j_lt_end = icmp ult i64 %j, %end
  br i1 %j_lt_end, label %both.present, label %use.left

both.present:
  %left.ptr = getelementptr inbounds i32, i32* %src, i64 %i
  %left.val = load i32, i32* %left.ptr, align 4
  %right.ptr = getelementptr inbounds i32, i32* %src, i64 %j
  %right.val = load i32, i32* %right.ptr, align 4
  %left_gt_right = icmp sgt i32 %left.val, %right.val
  br i1 %left_gt_right, label %use.right, label %use.left

use.left:
  %left.ptr2 = getelementptr inbounds i32, i32* %src, i64 %i
  %left.val2 = load i32, i32* %left.ptr2, align 4
  %i.next.left = add i64 %i, 1
  br label %merge.write

use.right:
  %right.ptr2 = getelementptr inbounds i32, i32* %src, i64 %j
  %right.val2 = load i32, i32* %right.ptr2, align 4
  %j.next.right = add i64 %j, 1
  br label %merge.write

merge.write:
  %val = phi i32 [ %left.val2, %use.left ], [ %right.val2, %use.right ]
  %i.next = phi i64 [ %i.next.left, %use.left ], [ %i, %use.right ]
  %j.next = phi i64 [ %j, %use.left ], [ %j.next.right, %use.right ]
  %dst.ptr = getelementptr inbounds i32, i32* %buf, i64 %k
  store i32 %val, i32* %dst.ptr, align 4
  %k.next = add i64 %k, 1
  br label %merge.loop.cond

inner.after.merge:
  %base.step = shl i64 %width, 1
  %base.next = add i64 %base, %base.step
  br label %inner.cond

outer.swap:
  %src.next = %buf
  %buf.next = %src
  %width.next = shl i64 %width, 1
  br label %outer.cond

after.outer:
  %src.cast = bitcast i32* %src to i8*
  %dest.cast = bitcast i32* %dest to i8*
  %same = icmp eq i32* %src, %dest
  br i1 %same, label %do.free, label %do.copy

do.copy:
  %call.memcpy = call i8* @memcpy(i8* %dest.cast, i8* %src.cast, i64 %size)
  br label %do.free

do.free:
  call void @free(i8* %tmp8)
  br label %ret

ret:
  ret void
}