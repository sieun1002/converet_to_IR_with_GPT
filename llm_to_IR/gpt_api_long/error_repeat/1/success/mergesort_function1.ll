; ModuleID = 'merge_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: merge_sort  ; Address: 0x11E9
; Intent: In-place ascending merge sort for i32 array using auxiliary buffer (confidence=0.95). Evidence: iterative width-doubling, merge of two runs, final memcpy back if needed.
; Preconditions: dest points to at least n elements (4*n bytes). If n <= 1 or malloc fails, dest is left unchanged.
; Postconditions: On successful allocation, dest is sorted in non-decreasing (signed) order.

; Only the needed extern declarations:
declare i8* @malloc(i64)
declare void @free(i8*)
declare i8* @memcpy(i8*, i8*, i64)

define dso_local void @merge_sort(i32* %dest, i64 %n) local_unnamed_addr {
entry:
  %cmp.n.le1 = icmp ule i64 %n, 1
  br i1 %cmp.n.le1, label %ret, label %alloc

alloc:
  %size = shl i64 %n, 2
  %raw = call i8* @malloc(i64 %size)
  %isnull = icmp eq i8* %raw, null
  br i1 %isnull, label %ret, label %init

init:
  %tmpBase = bitcast i8* %raw to i32*
  br label %outer.loop

outer.loop:
  %width = phi i64 [ 1, %init ], [ %width.next, %post.swap ]
  %src.cur = phi i32* [ %dest, %init ], [ %src.next, %post.swap ]
  %tmp.cur = phi i32* [ %tmpBase, %init ], [ %tmp.next, %post.swap ]
  %cond.outer = icmp ult i64 %width, %n
  br i1 %cond.outer, label %outer.body, label %outer.done

outer.body:
  br label %left.loop

left.loop:
  %left = phi i64 [ 0, %outer.body ], [ %left.next, %after.merge.run ]
  %left.cond = icmp ult i64 %left, %n
  br i1 %left.cond, label %compute.bounds, label %left.done

compute.bounds:
  %mid.tmp = add i64 %left, %width
  %mid.gt = icmp ugt i64 %mid.tmp, %n
  %mid = select i1 %mid.gt, i64 %n, i64 %mid.tmp
  %tw = shl i64 %width, 1
  %right.tmp = add i64 %left, %tw
  %right.gt = icmp ugt i64 %right.tmp, %n
  %right = select i1 %right.gt, i64 %n, i64 %right.tmp
  %i.init = add i64 %left, 0
  %j.init = add i64 %mid, 0
  %k.init = add i64 %left, 0
  br label %merge.loop

merge.loop:
  %i = phi i64 [ %i.init, %compute.bounds ], [ %i.next, %merge.iter.end ]
  %j = phi i64 [ %j.init, %compute.bounds ], [ %j.next, %merge.iter.end ]
  %k = phi i64 [ %k.init, %compute.bounds ], [ %k.next, %merge.iter.end ]
  %cond.k = icmp ult i64 %k, %right
  br i1 %cond.k, label %pick, label %after.merge.run

pick:
  %i.lt.mid = icmp ult i64 %i, %mid
  br i1 %i.lt.mid, label %check.right, label %take.right

check.right:
  %j.lt.right = icmp ult i64 %j, %right
  br i1 %j.lt.right, label %compare, label %take.left

compare:
  %pi.c = getelementptr inbounds i32, i32* %src.cur, i64 %i
  %vi.c = load i32, i32* %pi.c, align 4
  %pj.c = getelementptr inbounds i32, i32* %src.cur, i64 %j
  %vj.c = load i32, i32* %pj.c, align 4
  %vi.gt.vj = icmp sgt i32 %vi.c, %vj.c
  br i1 %vi.gt.vj, label %take.right, label %take.left

take.left:
  %pi = getelementptr inbounds i32, i32* %src.cur, i64 %i
  %val.l = load i32, i32* %pi, align 4
  %pk.l = getelementptr inbounds i32, i32* %tmp.cur, i64 %k
  store i32 %val.l, i32* %pk.l, align 4
  %i.next.l = add i64 %i, 1
  %k.next.l = add i64 %k, 1
  br label %merge.iter.end

take.right:
  %pj = getelementptr inbounds i32, i32* %src.cur, i64 %j
  %val.r = load i32, i32* %pj, align 4
  %pk.r = getelementptr inbounds i32, i32* %tmp.cur, i64 %k
  store i32 %val.r, i32* %pk.r, align 4
  %j.next.r = add i64 %j, 1
  %k.next.r = add i64 %k, 1
  br label %merge.iter.end

merge.iter.end:
  %i.next = phi i64 [ %i.next.l, %take.left ], [ %i, %take.right ]
  %j.next = phi i64 [ %j, %take.left ], [ %j.next.r, %take.right ]
  %k.next = phi i64 [ %k.next.l, %take.left ], [ %k.next.r, %take.right ]
  br label %merge.loop

after.merge.run:
  %tw2 = shl i64 %width, 1
  %left.next = add i64 %left, %tw2
  br label %left.loop

left.done:
  br label %post.swap

post.swap:
  %src.next = phi i32* [ %tmp.cur, %left.done ]
  %tmp.next = phi i32* [ %src.cur, %left.done ]
  %width.next = shl i64 %width, 1
  br label %outer.loop

outer.done:
  %need.copy = icmp ne i32* %src.cur, %dest
  br i1 %need.copy, label %do.memcpy, label %do.free

do.memcpy:
  %dest8 = bitcast i32* %dest to i8*
  %src8 = bitcast i32* %src.cur to i8*
  %_ = call i8* @memcpy(i8* %dest8, i8* %src8, i64 %size)
  br label %do.free

do.free:
  call void @free(i8* %raw)
  br label %ret

ret:
  ret void
}