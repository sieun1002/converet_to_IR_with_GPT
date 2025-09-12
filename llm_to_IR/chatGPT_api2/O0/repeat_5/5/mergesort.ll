; ModuleID = 'merge_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: merge_sort  ; Address: 0x11E9
; Intent: Stable bottom-up merge sort of 32-bit integers into dest (confidence=0.95). Evidence: iterative run-doubling with temp buffer; final memcpy back if needed.
; Preconditions: dest points to at least n i32 elements.
; Postconditions: dest[0..n) sorted non-decreasing; stable.

declare i8* @malloc(i64)
declare void @free(i8*)
declare i8* @memcpy(i8*, i8*, i64)

define dso_local void @merge_sort(i32* %dest, i64 %n) local_unnamed_addr {
entry:
  %cmp.n.le1 = icmp ule i64 %n, 1
  br i1 %cmp.n.le1, label %ret, label %alloc

alloc:
  %size = shl i64 %n, 2
  %buf.i8 = call i8* @malloc(i64 %size)
  %isnull = icmp eq i8* %buf.i8, null
  br i1 %isnull, label %ret, label %init

init:
  %buf = bitcast i8* %buf.i8 to i32*
  br label %outer.loop

outer.loop:
  %src.phi = phi i32* [ %dest, %init ], [ %tmp2, %after.inner ]
  %tmp.phi = phi i32* [ %buf, %init ], [ %src2, %after.inner ]
  %run.phi = phi i64 [ 1, %init ], [ %dblrun, %after.inner ]
  %cond.run = icmp ult i64 %run.phi, %n
  br i1 %cond.run, label %inner.head, label %after.outer

inner.head:
  %start.phi = phi i64 [ 0, %outer.loop ], [ %nextStart, %after.merge ]
  %has.more = icmp ult i64 %start.phi, %n
  br i1 %has.more, label %merge.init, label %after.inner

merge.init:
  %mid.tmp = add i64 %start.phi, %run.phi
  %mid.ok = icmp ule i64 %mid.tmp, %n
  %mid = select i1 %mid.ok, i64 %mid.tmp, i64 %n
  %tworun = shl i64 %run.phi, 1
  %end.tmp = add i64 %start.phi, %tworun
  %end.ok = icmp ule i64 %end.tmp, %n
  %end = select i1 %end.ok, i64 %end.tmp, i64 %n
  br label %merge.loop

merge.loop:
  %k.phi = phi i64 [ %start.phi, %merge.init ], [ %k.next.L, %copyLeft ], [ %k.next.R, %copyRight ]
  %i.phi = phi i64 [ %start.phi, %merge.init ], [ %i.next, %copyLeft ], [ %i.phi.keep, %copyRight ]
  %j.phi = phi i64 [ %mid, %merge.init ], [ %j.phi.keep, %copyLeft ], [ %j.next, %copyRight ]
  %cont = icmp ult i64 %k.phi, %end
  br i1 %cont, label %decide, label %after.merge

decide:
  %hasLeft = icmp ult i64 %i.phi, %mid
  %hasRight = icmp ult i64 %j.phi, %end
  br i1 %hasLeft, label %maybeCompare, label %doRight

maybeCompare:
  br i1 %hasRight, label %loadBoth, label %doLeft

loadBoth:
  %leftptr = getelementptr inbounds i32, i32* %src.phi, i64 %i.phi
  %left = load i32, i32* %leftptr, align 4
  %rightptr = getelementptr inbounds i32, i32* %src.phi, i64 %j.phi
  %right = load i32, i32* %rightptr, align 4
  %left_gt_right = icmp sgt i32 %left, %right
  br i1 %left_gt_right, label %doRight, label %doLeft

doLeft:
  %srcLptr = getelementptr inbounds i32, i32* %src.phi, i64 %i.phi
  %valL = load i32, i32* %srcLptr, align 4
  %tmpptrL = getelementptr inbounds i32, i32* %tmp.phi, i64 %k.phi
  store i32 %valL, i32* %tmpptrL, align 4
  %i.next = add i64 %i.phi, 1
  %k.next.L = add i64 %k.phi, 1
  br label %copyLeft

copyLeft:
  %j.phi.keep = %j.phi
  br label %merge.loop

doRight:
  %srcRptr = getelementptr inbounds i32, i32* %src.phi, i64 %j.phi
  %valR = load i32, i32* %srcRptr, align 4
  %tmpptrR = getelementptr inbounds i32, i32* %tmp.phi, i64 %k.phi
  store i32 %valR, i32* %tmpptrR, align 4
  %j.next = add i64 %j.phi, 1
  %k.next.R = add i64 %k.phi, 1
  br label %copyRight

copyRight:
  %i.phi.keep = %i.phi
  br label %merge.loop

after.merge:
  %nextStart = add i64 %start.phi, %tworun
  br label %inner.head

after.inner:
  %src2 = %tmp.phi
  %tmp2 = %src.phi
  %dblrun = shl i64 %run.phi, 1
  br label %outer.loop

after.outer:
  %needCopy = icmp ne i32* %src.phi, %dest
  br i1 %needCopy, label %doMemcpy, label %afterMemcpy

doMemcpy:
  %bytes = shl i64 %n, 2
  %dest.i8 = bitcast i32* %dest to i8*
  %src.i8 = bitcast i32* %src.phi to i8*
  %memcpy.ret = call i8* @memcpy(i8* %dest.i8, i8* %src.i8, i64 %bytes)
  br label %afterMemcpy

afterMemcpy:
  call void @free(i8* %buf.i8)
  br label %ret

ret:
  ret void
}