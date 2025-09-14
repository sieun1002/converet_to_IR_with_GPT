; ModuleID = 'merge_sort.ll'

declare noalias i8* @malloc(i64)
declare void @free(i8*)
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i1 immarg)

define void @merge_sort(i32* nocapture %dest, i64 %n) local_unnamed_addr {
entry:
  %cmp.n.le1 = icmp ule i64 %n, 1
  br i1 %cmp.n.le1, label %ret, label %alloc

alloc:
  %size = shl i64 %n, 2
  %mem = call noalias i8* @malloc(i64 %size)
  %null = icmp eq i8* %mem, null
  br i1 %null, label %ret, label %init

init:
  %temp = bitcast i8* %mem to i32*
  br label %outer.cond

outer.cond:
  %run = phi i64 [ 1, %init ], [ %run.next, %outer.swap ]
  %src.cur = phi i32* [ %dest, %init ], [ %src.next, %outer.swap ]
  %tmp.cur = phi i32* [ %temp, %init ], [ %tmp.next, %outer.swap ]
  %run.lt.n = icmp ult i64 %run, %n
  br i1 %run.lt.n, label %inner.init, label %after.outer

inner.init:
  %base = phi i64 [ 0, %outer.cond ], [ %base.next, %inner.next ]
  %base.lt.n = icmp ult i64 %base, %n
  br i1 %base.lt.n, label %compute.bounds, label %outer.swap

compute.bounds:
  %mid0 = add i64 %base, %run
  %mid.lt.n = icmp ult i64 %mid0, %n
  %mid = select i1 %mid.lt.n, i64 %mid0, i64 %n
  %run2 = shl i64 %run, 1
  %end0 = add i64 %base, %run2
  %end.lt.n = icmp ult i64 %end0, %n
  %end = select i1 %end.lt.n, i64 %end0, i64 %n
  br label %merge.cond

merge.cond:
  %i = phi i64 [ %base, %compute.bounds ], [ %i.next, %inc.k ]
  %j = phi i64 [ %mid, %compute.bounds ], [ %j.next, %inc.k ]
  %k = phi i64 [ %base, %compute.bounds ], [ %k.next, %inc.k ]
  %k.lt.end = icmp ult i64 %k, %end
  br i1 %k.lt.end, label %merge.body, label %merge.end

merge.body:
  %i.lt.mid = icmp ult i64 %i, %mid
  br i1 %i.lt.mid, label %check.right, label %take.right

check.right:
  %j.lt.end = icmp ult i64 %j, %end
  br i1 %j.lt.end, label %compare, label %take.left

compare:
  %li.ptr = getelementptr inbounds i32, i32* %src.cur, i64 %i
  %li = load i32, i32* %li.ptr, align 4
  %rj.ptr = getelementptr inbounds i32, i32* %src.cur, i64 %j
  %rj = load i32, i32* %rj.ptr, align 4
  %left.gt.right = icmp sgt i32 %li, %rj
  br i1 %left.gt.right, label %take.right, label %take.left

take.left:
  %left.ptr = getelementptr inbounds i32, i32* %src.cur, i64 %i
  %left.val = load i32, i32* %left.ptr, align 4
  %dst.ptr.l = getelementptr inbounds i32, i32* %tmp.cur, i64 %k
  store i32 %left.val, i32* %dst.ptr.l, align 4
  %i.inc = add i64 %i, 1
  br label %inc.k

take.right:
  %right.ptr = getelementptr inbounds i32, i32* %src.cur, i64 %j
  %right.val = load i32, i32* %right.ptr, align 4
  %dst.ptr.r = getelementptr inbounds i32, i32* %tmp.cur, i64 %k
  store i32 %right.val, i32* %dst.ptr.r, align 4
  %j.inc = add i64 %j, 1
  br label %inc.k

inc.k:
  %i.next = phi i64 [ %i.inc, %take.left ], [ %i, %take.right ]
  %j.next = phi i64 [ %j, %take.left ], [ %j.inc, %take.right ]
  %k.next = add i64 %k, 1
  br label %merge.cond

merge.end:
  br label %inner.next

inner.next:
  %base.step = shl i64 %run, 1
  %base.next = add i64 %base, %base.step
  br label %inner.init

outer.swap:
  %src.next = %tmp.cur
  %tmp.next = %src.cur
  %run.next = shl i64 %run, 1
  br label %outer.cond

after.outer:
  %need.copy = icmp ne i32* %src.cur, %dest
  br i1 %need.copy, label %do.copy, label %do.free

do.copy:
  %dest8 = bitcast i32* %dest to i8*
  %src8 = bitcast i32* %src.cur to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %dest8, i8* align 4 %src8, i64 %size, i1 false)
  br label %do.free

do.free:
  call void @free(i8* %mem)
  br label %ret

ret:
  ret void
}