; ModuleID = 'merge_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: merge_sort ; Address: 0x11E9
; Intent: stable iterative mergesort of 32-bit ints into ascending order (confidence=0.95). Evidence: width-doubling passes with temp buffer; final memcpy back if needed.
; Preconditions: dest points to at least n 32-bit integers (4*n bytes valid).
; Postconditions: if n>1 and allocation succeeds, dest[0..n) sorted nondecreasing; stable.

; Only the necessary external declarations:
declare noalias i8* @malloc(i64)
declare void @free(i8*)
declare i8* @memcpy(i8*, i8*, i64)

define dso_local void @merge_sort(i32* nocapture %dest, i64 %n) local_unnamed_addr {
entry:
  %n_le1 = icmp ule i64 %n, 1
  br i1 %n_le1, label %ret, label %alloc

alloc:
  %size = shl i64 %n, 2
  %tmp_i8 = call i8* @malloc(i64 %size)
  %isnull = icmp eq i8* %tmp_i8, null
  br i1 %isnull, label %ret, label %init

init:
  %tmp = bitcast i8* %tmp_i8 to i32*
  br label %outer.check

outer.check:
  %width.cur = phi i64 [ 1, %init ], [ %width.next, %outer.end ]
  %src.cur = phi i32* [ %dest, %init ], [ %buf.cur, %outer.end ]
  %buf.cur = phi i32* [ %tmp, %init ], [ %src.cur, %outer.end ]
  %cond.outer = icmp ult i64 %width.cur, %n
  br i1 %cond.outer, label %inner.init, label %after.outer

inner.init:
  %two_w = shl i64 %width.cur, 1
  %i.cur = phi i64 [ 0, %outer.check ], [ %i.next, %inner.end ]
  %i_cmp = icmp ult i64 %i.cur, %n
  br i1 %i_cmp, label %merge.setup, label %outer.end

merge.setup:
  %left = %i.cur
  %mid.cand = add i64 %i.cur, %width.cur
  %mid.lt = icmp ult i64 %mid.cand, %n
  %mid = select i1 %mid.lt, i64 %mid.cand, i64 %n
  %right.cand = add i64 %i.cur, %two_w
  %right.lt = icmp ult i64 %right.cand, %n
  %right = select i1 %right.lt, i64 %right.cand, i64 %n
  %a0 = %left
  %b0 = %mid
  %k0 = %left
  br label %merge.loop

merge.loop:
  %a = phi i64 [ %a0, %merge.setup ], [ %a.next, %merge.body.end ]
  %b = phi i64 [ %b0, %merge.setup ], [ %b.next, %merge.body.end ]
  %k = phi i64 [ %k0, %merge.setup ], [ %k.next, %merge.body.end ]
  %cont = icmp ult i64 %k, %right
  br i1 %cont, label %merge.body, label %inner.end

merge.body:
  %condA = icmp ult i64 %a, %mid
  br i1 %condA, label %checkB, label %pick.right

checkB:
  %condB = icmp ult i64 %b, %right
  br i1 %condB, label %compare, label %pick.left

compare:
  %pa = getelementptr inbounds i32, i32* %src.cur, i64 %a
  %va = load i32, i32* %pa, align 4
  %pb = getelementptr inbounds i32, i32* %src.cur, i64 %b
  %vb = load i32, i32* %pb, align 4
  %cmp = icmp sgt i32 %va, %vb
  br i1 %cmp, label %pick.right, label %pick.left

pick.left:
  %pa.l = getelementptr inbounds i32, i32* %src.cur, i64 %a
  %valL = load i32, i32* %pa.l, align 4
  %a.inc = add i64 %a, 1
  br label %store

pick.right:
  %pb.r = getelementptr inbounds i32, i32* %src.cur, i64 %b
  %valR = load i32, i32* %pb.r, align 4
  %b.inc = add i64 %b, 1
  br label %store

store:
  %val = phi i32 [ %valL, %pick.left ], [ %valR, %pick.right ]
  %a.next = phi i64 [ %a.inc, %pick.left ], [ %a, %pick.right ]
  %b.next = phi i64 [ %b, %pick.left ], [ %b.inc, %pick.right ]
  %pk = getelementptr inbounds i32, i32* %buf.cur, i64 %k
  store i32 %val, i32* %pk, align 4
  %k.next = add i64 %k, 1
  br label %merge.body.end

merge.body.end:
  br label %merge.loop

inner.end:
  %i.next = add i64 %i.cur, %two_w
  br label %inner.init

outer.end:
  %width.next = shl i64 %width.cur, 1
  br label %outer.check

after.outer:
  %neq = icmp ne i32* %src.cur, %dest
  br i1 %neq, label %do.copy, label %free.node

do.copy:
  %dest.i8 = bitcast i32* %dest to i8*
  %src.i8 = bitcast i32* %src.cur to i8*
  %size2 = shl i64 %n, 2
  %_ = call i8* @memcpy(i8* %dest.i8, i8* %src.i8, i64 %size2)
  br label %free.node

free.node:
  call void @free(i8* %tmp_i8)
  br label %ret

ret:
  ret void
}