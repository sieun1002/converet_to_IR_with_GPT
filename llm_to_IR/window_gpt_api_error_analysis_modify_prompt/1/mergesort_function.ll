target triple = "x86_64-pc-windows-msvc"

declare i8* @malloc(i64)
declare void @free(i8*)
declare i8* @memcpy(i8*, i8*, i64)

define void @merge_sort(i32* %arg_0, i64 %arg_8) {
entry:
  %cmp_n_le_1 = icmp ule i64 %arg_8, 1
  br i1 %cmp_n_le_1, label %ret, label %alloc

alloc:
  %size.bytes = shl i64 %arg_8, 2
  %malloc.ptr = call i8* @malloc(i64 %size.bytes)
  %isnull = icmp eq i8* %malloc.ptr, null
  br i1 %isnull, label %ret, label %init

init:
  %block = bitcast i8* %malloc.ptr to i32*
  br label %outer.cond

outer.cond:
  %run = phi i64 [ 1, %init ], [ %run.next, %outer.swap ]
  %src = phi i32* [ %arg_0, %init ], [ %tmp.cur, %outer.swap ]
  %tmp = phi i32* [ %block, %init ], [ %src.cur, %outer.swap ]
  %cond.run = icmp ult i64 %run, %arg_8
  br i1 %cond.run, label %inner.init, label %after.outer

inner.init:
  br label %inner.cond

inner.cond:
  %s = phi i64 [ 0, %inner.init ], [ %s.next, %after.merge ]
  %cond.s = icmp ult i64 %s, %arg_8
  br i1 %cond.s, label %compute.bounds, label %outer.swap

compute.bounds:
  %mid.cand = add i64 %s, %run
  %mid.gt.n = icmp ugt i64 %mid.cand, %arg_8
  %mid = select i1 %mid.gt.n, i64 %arg_8, i64 %mid.cand
  %two.run = add i64 %run, %run
  %end.cand = add i64 %s, %two.run
  %end.gt.n = icmp ugt i64 %end.cand, %arg_8
  %end = select i1 %end.gt.n, i64 %arg_8, i64 %end.cand
  br label %merge.cond

merge.cond:
  %i = phi i64 [ %s, %compute.bounds ], [ %i.next, %after.store ]
  %j = phi i64 [ %mid, %compute.bounds ], [ %j.next, %after.store ]
  %k = phi i64 [ %s, %compute.bounds ], [ %k.next, %after.store ]
  %cond.k = icmp ult i64 %k, %end
  br i1 %cond.k, label %choose, label %after.merge

choose:
  %i.ge.mid = icmp uge i64 %i, %mid
  br i1 %i.ge.mid, label %take.right, label %check.j

check.j:
  %j.ge.end = icmp uge i64 %j, %end
  br i1 %j.ge.end, label %take.left, label %compare

compare:
  %lhs.ptr = getelementptr inbounds i32, i32* %src, i64 %i
  %lhs = load i32, i32* %lhs.ptr, align 4
  %rhs.ptr = getelementptr inbounds i32, i32* %src, i64 %j
  %rhs = load i32, i32* %rhs.ptr, align 4
  %lhs.gt.rhs = icmp sgt i32 %lhs, %rhs
  br i1 %lhs.gt.rhs, label %take.right, label %take.left

take.left:
  %lhs.ptr.tl = getelementptr inbounds i32, i32* %src, i64 %i
  %valL = load i32, i32* %lhs.ptr.tl, align 4
  %dst.ptrL = getelementptr inbounds i32, i32* %tmp, i64 %k
  store i32 %valL, i32* %dst.ptrL, align 4
  %i.inc = add i64 %i, 1
  br label %after.store

take.right:
  %rhs.ptr.tr = getelementptr inbounds i32, i32* %src, i64 %j
  %valR = load i32, i32* %rhs.ptr.tr, align 4
  %dst.ptrR = getelementptr inbounds i32, i32* %tmp, i64 %k
  store i32 %valR, i32* %dst.ptrR, align 4
  %j.inc = add i64 %j, 1
  br label %after.store

after.store:
  %i.next = phi i64 [ %i.inc, %take.left ], [ %i, %take.right ]
  %j.next = phi i64 [ %j, %take.left ], [ %j.inc, %take.right ]
  %k.next = add i64 %k, 1
  br label %merge.cond

after.merge:
  %two.run.2 = add i64 %run, %run
  %s.next = add i64 %s, %two.run.2
  br label %inner.cond

outer.swap:
  %src.cur = %src
  %tmp.cur = %tmp
  %run.next = shl i64 %run, 1
  br label %outer.cond

after.outer:
  %src.eq.arg0 = icmp eq i32* %src, %arg_0
  br i1 %src.eq.arg0, label %free.block, label %do.memcpy

do.memcpy:
  %dst.cast = bitcast i32* %arg_0 to i8*
  %src.cast = bitcast i32* %src to i8*
  %memcpy.ret = call i8* @memcpy(i8* %dst.cast, i8* %src.cast, i64 %size.bytes)
  br label %free.block

free.block:
  call void @free(i8* %malloc.ptr)
  br label %ret

ret:
  ret void
}