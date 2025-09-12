; ModuleID = 'merge_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: merge_sort  ; Address: 0x11E9
; Intent: Bottom-up stable merge sort of i32 array using temporary buffer and signed comparisons (confidence=0.98). Evidence: doubling run size, merge loops with signed jg, malloc n*4 and final memcpy.
; Preconditions: If %n > 0, %dest points to at least %n contiguous i32 elements.
; Postconditions: On successful allocation, %dest is sorted ascending (signed) and stable; if allocation fails or %n <= 1, %dest is unchanged.

; Only the needed extern declarations:
declare i8* @malloc(i64)
declare void @free(i8*)
declare i8* @memcpy(i8*, i8*, i64)

define dso_local void @merge_sort(i32* %dest, i64 %n) local_unnamed_addr {
entry:
  %cmp_n_le_1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le_1, label %ret, label %alloc

alloc:
  %size = shl i64 %n, 2
  %tmp_i8 = call i8* @malloc(i64 %size)
  %isnull = icmp eq i8* %tmp_i8, null
  br i1 %isnull, label %ret, label %init

init:
  %tmp = bitcast i8* %tmp_i8 to i32*
  br label %outer.loop

outer.loop:
  %run = phi i64 [ 1, %init ], [ %run2, %outer.latch ]
  %src = phi i32* [ %dest, %init ], [ %new_src, %outer.latch ]
  %buf = phi i32* [ %tmp, %init ], [ %new_buf, %outer.latch ]
  %run_lt_n = icmp ult i64 %run, %n
  br i1 %run_lt_n, label %inner.init, label %after.outer

inner.init:
  br label %inner.cond

inner.cond:
  %base = phi i64 [ 0, %inner.init ], [ %base.next, %merge.done ]
  %base_lt_n = icmp ult i64 %base, %n
  br i1 %base_lt_n, label %merge.setup, label %outer.latch

merge.setup:
  %start = add i64 %base, 0
  %t1 = add i64 %base, %run
  %t1cmp = icmp ult i64 %t1, %n
  %mid = select i1 %t1cmp, i64 %t1, i64 %n
  %t2 = add i64 %t1, %run
  %t2cmp = icmp ult i64 %t2, %n
  %end = select i1 %t2cmp, i64 %t2, i64 %n
  br label %merge.cond

merge.cond:
  %i = phi i64 [ %start, %merge.setup ], [ %i.next, %choose.left ], [ %i, %choose.right ]
  %j = phi i64 [ %mid, %merge.setup ], [ %j, %choose.left ], [ %j.next, %choose.right ]
  %k = phi i64 [ %start, %merge.setup ], [ %k.nextL, %choose.left ], [ %k.nextR, %choose.right ]
  %kltend = icmp ult i64 %k, %end
  br i1 %kltend, label %choose.entry, label %merge.done

choose.entry:
  %iltmid = icmp ult i64 %i, %mid
  br i1 %iltmid, label %check.right.avail, label %choose.right

check.right.avail:
  %jltend = icmp ult i64 %j, %end
  br i1 %jltend, label %both.avail, label %choose.left

both.avail:
  %i.ptr = getelementptr inbounds i32, i32* %src, i64 %i
  %left = load i32, i32* %i.ptr, align 4
  %j.ptr = getelementptr inbounds i32, i32* %src, i64 %j
  %right = load i32, i32* %j.ptr, align 4
  %cmpSigned = icmp sgt i32 %left, %right
  br i1 %cmpSigned, label %choose.right, label %choose.left

choose.left:
  %src_i = getelementptr inbounds i32, i32* %src, i64 %i
  %valL = load i32, i32* %src_i, align 4
  %buf_kL = getelementptr inbounds i32, i32* %buf, i64 %k
  store i32 %valL, i32* %buf_kL, align 4
  %i.next = add i64 %i, 1
  %k.nextL = add i64 %k, 1
  br label %merge.cond

choose.right:
  %src_j = getelementptr inbounds i32, i32* %src, i64 %j
  %valR = load i32, i32* %src_j, align 4
  %buf_kR = getelementptr inbounds i32, i32* %buf, i64 %k
  store i32 %valR, i32* %buf_kR, align 4
  %j.next = add i64 %j, 1
  %k.nextR = add i64 %k, 1
  br label %merge.cond

merge.done:
  %tworun = add i64 %run, %run
  %base.next = add i64 %base, %tworun
  br label %inner.cond

outer.latch:
  %new_src = %buf
  %new_buf = %src
  %run2 = shl i64 %run, 1
  br label %outer.loop

after.outer:
  %src_eq_dest = icmp eq i32* %src, %dest
  br i1 %src_eq_dest, label %free.block, label %memcpy.block

memcpy.block:
  %dest.i8 = bitcast i32* %dest to i8*
  %src.i8 = bitcast i32* %src to i8*
  call i8* @memcpy(i8* %dest.i8, i8* %src.i8, i64 %size)
  br label %free.block

free.block:
  call void @free(i8* %tmp_i8)
  br label %ret

ret:
  ret void
}