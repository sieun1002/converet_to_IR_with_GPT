; ModuleID = 'merge_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: merge_sort  ; Address: 0x11E9
; Intent: Bottom-up iterative merge sort on 32-bit ints (confidence=0.95). Evidence: doubling run width, two-way merge into temp buffer then swap
; Preconditions: dest points to at least n 32-bit elements; n is the element count (unsigned). If malloc fails or n <= 1, array remains unchanged.

; Only the needed extern declarations:
declare i8* @malloc(i64)
declare void @free(i8*)
declare i8* @memcpy(i8*, i8*, i64)

define dso_local void @merge_sort(i32* %dest, i64 %n) local_unnamed_addr {
entry:
  %cmp_small = icmp ule i64 %n, 1
  br i1 %cmp_small, label %ret, label %alloc

alloc:
  %size_bytes = shl i64 %n, 2
  %raw = call i8* @malloc(i64 %size_bytes)
  %isnull = icmp eq i8* %raw, null
  br i1 %isnull, label %ret, label %init

init:
  %buf0 = bitcast i8* %raw to i32*
  br label %outer.cond

outer.cond:
  %width = phi i64 [ 1, %init ], [ %width.next, %after.pass ]
  %src = phi i32* [ %dest, %init ], [ %src.swapped, %after.pass ]
  %buf = phi i32* [ %buf0, %init ], [ %buf.swapped, %after.pass ]
  %cmpw = icmp ult i64 %width, %n
  br i1 %cmpw, label %pass.loop.cond, label %after.outer

pass.loop.cond:
  %pos = phi i64 [ 0, %outer.cond ], [ %pos.next, %merge.pass.end ]
  %pos_lt = icmp ult i64 %pos, %n
  br i1 %pos_lt, label %merge.init, label %after.pass

merge.init:
  %mid.cand = add i64 %pos, %width
  %mid.le = icmp ule i64 %mid.cand, %n
  %mid = select i1 %mid.le, i64 %mid.cand, i64 %n
  %width2 = shl i64 %width, 1
  %end.cand = add i64 %pos, %width2
  %end.le = icmp ule i64 %end.cand, %n
  %end = select i1 %end.le, i64 %end.cand, i64 %n
  br label %merge.cond

merge.cond:
  %i = phi i64 [ %pos, %merge.init ], [ %i.next, %left.store ], [ %i, %right.store ]
  %j = phi i64 [ %mid, %merge.init ], [ %j, %left.store ], [ %j.next, %right.store ]
  %k = phi i64 [ %pos, %merge.init ], [ %k.next, %left.store ], [ %k.next2, %right.store ]
  %k_lt_end = icmp ult i64 %k, %end
  br i1 %k_lt_end, label %check.i, label %merge.pass.end

check.i:
  %i_lt_mid = icmp ult i64 %i, %mid
  br i1 %i_lt_mid, label %check.j, label %right.load

check.j:
  %j_lt_end = icmp ult i64 %j, %end
  br i1 %j_lt_end, label %both.inrange, label %left.load

both.inrange:
  %ptr_i = getelementptr inbounds i32, i32* %src, i64 %i
  %vi = load i32, i32* %ptr_i, align 4
  %ptr_j = getelementptr inbounds i32, i32* %src, i64 %j
  %vj = load i32, i32* %ptr_j, align 4
  %vi_gt_vj = icmp sgt i32 %vi, %vj
  br i1 %vi_gt_vj, label %right.store, label %left.store

left.load:
  %ptr_i2 = getelementptr inbounds i32, i32* %src, i64 %i
  %vi2 = load i32, i32* %ptr_i2, align 4
  br label %left.store

left.store:
  %val.left = phi i32 [ %vi, %both.inrange ], [ %vi2, %left.load ]
  %dstptr = getelementptr inbounds i32, i32* %buf, i64 %k
  store i32 %val.left, i32* %dstptr, align 4
  %i.next = add i64 %i, 1
  %k.next = add i64 %k, 1
  br label %merge.cond

right.load:
  %ptr_j2 = getelementptr inbounds i32, i32* %src, i64 %j
  %vj2 = load i32, i32* %ptr_j2, align 4
  br label %right.store

right.store:
  %val.right = phi i32 [ %vj, %both.inrange ], [ %vj2, %right.load ]
  %dstptr2 = getelementptr inbounds i32, i32* %buf, i64 %k
  store i32 %val.right, i32* %dstptr2, align 4
  %j.next = add i64 %j, 1
  %k.next2 = add i64 %k, 1
  br label %merge.cond

merge.pass.end:
  %width2.ph = shl i64 %width, 1
  %pos.next = add i64 %pos, %width2.ph
  br label %pass.loop.cond

after.pass:
  %src.swapped = %buf
  %buf.swapped = %src
  %width.next = shl i64 %width, 1
  br label %outer.cond

after.outer:
  %src.ne = icmp ne i32* %src, %dest
  br i1 %src.ne, label %do.memcpy, label %free

do.memcpy:
  %dest8 = bitcast i32* %dest to i8*
  %src8 = bitcast i32* %src to i8*
  %callmc = call i8* @memcpy(i8* %dest8, i8* %src8, i64 %size_bytes)
  br label %free

free:
  call void @free(i8* %raw)
  br label %ret

ret:
  ret void
}