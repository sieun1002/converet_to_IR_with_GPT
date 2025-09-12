; ModuleID = 'merge_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: merge_sort ; Address: 0x11E9
; Intent: bottom-up iterative merge sort of 32-bit signed integers (confidence=0.98). Evidence: alloc n*4 buffer, iterative merge with signed jg, final memcpy and free
; Preconditions: dest points to at least n 32-bit elements
; Postconditions: dest sorted ascending (signed); if n<=1 or malloc fails, dest unchanged

; Only the necessary external declarations:
declare noalias i8* @malloc(i64) local_unnamed_addr
declare void @free(i8*) local_unnamed_addr
declare i8* @memcpy(i8*, i8*, i64) local_unnamed_addr

define dso_local void @merge_sort(i32* %dest, i64 %n) local_unnamed_addr {
entry:
  %cond.le1 = icmp ule i64 %n, 1
  br i1 %cond.le1, label %ret, label %alloc

alloc:
  %size.bytes = shl i64 %n, 2
  %raw.buf = call i8* @malloc(i64 %size.bytes)
  %buf.init = bitcast i8* %raw.buf to i32*
  %isnull = icmp eq i32* %buf.init, null
  br i1 %isnull, label %ret, label %init

init:
  br label %outer

outer:
  %run = phi i64 [ 1, %init ], [ %run.next, %swap ]
  %src.phi = phi i32* [ %dest, %init ], [ %buf.next, %swap ]
  %buf.phi = phi i32* [ %buf.init, %init ], [ %src.next, %swap ]
  %cont = icmp ult i64 %run, %n
  br i1 %cont, label %outer.body, label %after.outer

outer.body:
  br label %base.loop

base.loop:
  %base = phi i64 [ 0, %outer.body ], [ %base.next, %merge.done ]
  %has.more = icmp ult i64 %base, %n
  br i1 %has.more, label %compute.bounds, label %swap

compute.bounds:
  %mid.tmp = add i64 %base, %run
  %mid.lt = icmp ult i64 %mid.tmp, %n
  %mid = select i1 %mid.lt, i64 %mid.tmp, i64 %n
  %two = add i64 %run, %run
  %right.tmp = add i64 %base, %two
  %right.lt = icmp ult i64 %right.tmp, %n
  %right = select i1 %right.lt, i64 %right.tmp, i64 %n
  br label %merge.loop

merge.loop:
  %i = phi i64 [ %base, %compute.bounds ], [ %i.next.phi, %merge.iter.end ]
  %j = phi i64 [ %mid,  %compute.bounds ], [ %j.next.phi, %merge.iter.end ]
  %k = phi i64 [ %base, %compute.bounds ], [ %k.next.phi, %merge.iter.end ]
  %k.lt.right = icmp ult i64 %k, %right
  br i1 %k.lt.right, label %select.side, label %merge.done

select.side:
  %i.lt.mid = icmp ult i64 %i, %mid
  br i1 %i.lt.mid, label %check.right, label %take.right

check.right:
  %j.ge.right = icmp uge i64 %j, %right
  br i1 %j.ge.right, label %take.left, label %compare

compare:
  %ptr.i = getelementptr inbounds i32, i32* %src.phi, i64 %i
  %val.i = load i32, i32* %ptr.i, align 4
  %ptr.j = getelementptr inbounds i32, i32* %src.phi, i64 %j
  %val.j = load i32, i32* %ptr.j, align 4
  %i.le.j = icmp sle i32 %val.i, %val.j
  br i1 %i.le.j, label %take.left.values, label %take.right.values

take.left:
  %ptr.i.l = getelementptr inbounds i32, i32* %src.phi, i64 %i
  %val.i.l = load i32, i32* %ptr.i.l, align 4
  br label %store.left

take.left.values:
  br label %store.left

store.left:
  %val.left = phi i32 [ %val.i.l, %take.left ], [ %val.i, %take.left.values ]
  %buf.k.l = getelementptr inbounds i32, i32* %buf.phi, i64 %k
  store i32 %val.left, i32* %buf.k.l, align 4
  %i.next = add i64 %i, 1
  %j.next = %j
  %k.next = add i64 %k, 1
  br label %merge.iter.end

take.right:
  %ptr.j.r = getelementptr inbounds i32, i32* %src.phi, i64 %j
  %val.j.r = load i32, i32* %ptr.j.r, align 4
  br label %store.right

take.right.values:
  br label %store.right

store.right:
  %val.right = phi i32 [ %val.j.r, %take.right ], [ %val.j, %take.right.values ]
  %buf.k.r = getelementptr inbounds i32, i32* %buf.phi, i64 %k
  store i32 %val.right, i32* %buf.k.r, align 4
  %i.next2 = %i
  %j.next2 = add i64 %j, 1
  %k.next2 = add i64 %k, 1
  br label %merge.iter.end

merge.iter.end:
  %i.next.phi = phi i64 [ %i.next, %store.left ], [ %i.next2, %store.right ]
  %j.next.phi = phi i64 [ %j.next, %store.left ], [ %j.next2, %store.right ]
  %k.next.phi = phi i64 [ %k.next, %store.left ], [ %k.next2, %store.right ]
  br label %merge.loop

merge.done:
  %two.step = add i64 %run, %run
  %base.next = add i64 %base, %two.step
  br label %base.loop

swap:
  %src.next = %buf.phi
  %buf.next = %src.phi
  %run.next = shl i64 %run, 1
  br label %outer

after.outer:
  %src.final = %src.phi
  %same.as.dest = icmp eq i32* %src.final, %dest
  br i1 %same.as.dest, label %free.block, label %copyback

copyback:
  %bytes = shl i64 %n, 2
  %dest8 = bitcast i32* %dest to i8*
  %src8 = bitcast i32* %src.final to i8*
  call i8* @memcpy(i8* %dest8, i8* %src8, i64 %bytes)
  br label %free.block

free.block:
  call void @free(i8* %raw.buf)
  br label %ret

ret:
  ret void
}