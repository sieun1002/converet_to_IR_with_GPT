; ModuleID = 'dijkstra'
target triple = "x86_64-pc-windows-msvc"

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define void @dijkstra(i32* %arg0, i64 %arg1, i64 %arg2, i32* %arg3, i32* %arg4) {
entry:
  %cmp_n_zero = icmp eq i64 %arg1, 0
  %cmp_src_ge = icmp uge i64 %arg2, %arg1
  %early_or = or i1 %cmp_n_zero, %cmp_src_ge
  br i1 %early_or, label %ret, label %alloc

alloc:
  %size = shl i64 %arg1, 2
  %raw = call i8* @malloc(i64 %size)
  %block = bitcast i8* %raw to i32*
  %isnull = icmp eq i32* %block, null
  br i1 %isnull, label %ret, label %init

init:
  br label %init.loop

init.loop:
  %i = phi i64 [ 0, %init ], [ %i.next, %init.cont ]
  %dist.ptr = getelementptr inbounds i32, i32* %arg3, i64 %i
  store i32 1061109567, i32* %dist.ptr, align 4
  %par.ptr = getelementptr inbounds i32, i32* %arg4, i64 %i
  store i32 -1, i32* %par.ptr, align 4
  %blk.ptr = getelementptr inbounds i32, i32* %block, i64 %i
  store i32 0, i32* %blk.ptr, align 4
  %i.next = add i64 %i, 1
  br label %init.cond

init.cond:
  %i.lt = icmp ult i64 %i.next, %arg1
  br i1 %i.lt, label %init.cont, label %post.init

init.cont:
  br label %init.loop

post.init:
  %src.ptr = getelementptr inbounds i32, i32* %arg3, i64 %arg2
  store i32 0, i32* %src.ptr, align 4
  br label %outer.cond

outer.cond:
  %t = phi i64 [ 0, %post.init ], [ %t.next, %after.inner ]
  %t.lt = icmp ult i64 %t, %arg1
  br i1 %t.lt, label %findmin.init, label %do.free

findmin.init:
  br label %findmin.loop

findmin.loop:
  %j = phi i64 [ 0, %findmin.init ], [ %j.next, %findmin.cont ]
  %u = phi i64 [ %arg1, %findmin.init ], [ %u.next, %findmin.cont ]
  %min = phi i32 [ 1061109567, %findmin.init ], [ %min.next, %findmin.cont ]
  %j.lt = icmp ult i64 %j, %arg1
  br i1 %j.lt, label %findmin.body, label %findmin.end

findmin.body:
  %blk.j.ptr = getelementptr inbounds i32, i32* %block, i64 %j
  %blk.j = load i32, i32* %blk.j.ptr, align 4
  %blk.j.zero = icmp eq i32 %blk.j, 0
  br i1 %blk.j.zero, label %findmin.maybe, label %findmin.join

findmin.maybe:
  %dist.j.ptr = getelementptr inbounds i32, i32* %arg3, i64 %j
  %dist.j = load i32, i32* %dist.j.ptr, align 4
  %cmp.le = icmp sle i32 %min, %dist.j
  br i1 %cmp.le, label %findmin.join, label %findmin.update

findmin.update:
  br label %findmin.join

findmin.join:
  %u.next = phi i64 [ %u, %findmin.body ], [ %u, %findmin.maybe ], [ %j, %findmin.update ]
  %min.next = phi i32 [ %min, %findmin.body ], [ %min, %findmin.maybe ], [ %dist.j, %findmin.update ]
  br label %findmin.cont

findmin.cont:
  %j.next = add i64 %j, 1
  br label %findmin.loop

findmin.end:
  %u.eq.none = icmp eq i64 %u, %arg1
  br i1 %u.eq.none, label %do.free, label %visit.mark

visit.mark:
  %blk.u.ptr = getelementptr inbounds i32, i32* %block, i64 %u
  store i32 1, i32* %blk.u.ptr, align 4
  br label %v.cond

v.cond:
  %v = phi i64 [ 0, %visit.mark ], [ %v.next, %v.cont ]
  %v.lt = icmp ult i64 %v, %arg1
  br i1 %v.lt, label %v.body, label %after.inner

v.body:
  %mul = mul i64 %u, %arg1
  %idx.sum = add i64 %mul, %v
  %edge.ptr = getelementptr inbounds i32, i32* %arg0, i64 %idx.sum
  %w = load i32, i32* %edge.ptr, align 4
  %w.neg = icmp slt i32 %w, 0
  br i1 %w.neg, label %v.cont, label %check.blk.v

check.blk.v:
  %blk.v.ptr = getelementptr inbounds i32, i32* %block, i64 %v
  %blk.v = load i32, i32* %blk.v.ptr, align 4
  %blk.v.zero = icmp eq i32 %blk.v, 0
  br i1 %blk.v.zero, label %compute.du, label %v.cont

compute.du:
  %dist.u.ptr = getelementptr inbounds i32, i32* %arg3, i64 %u
  %du = load i32, i32* %dist.u.ptr, align 4
  %du.is.inf = icmp eq i32 %du, 1061109567
  br i1 %du.is.inf, label %v.cont, label %compute.new

compute.new:
  %new = add i32 %du, %w
  %dist.v.ptr = getelementptr inbounds i32, i32* %arg3, i64 %v
  %old = load i32, i32* %dist.v.ptr, align 4
  %ge = icmp sge i32 %new, %old
  br i1 %ge, label %v.cont, label %do.update

do.update:
  store i32 %new, i32* %dist.v.ptr, align 4
  %u.tr = trunc i64 %u to i32
  %par.v.ptr = getelementptr inbounds i32, i32* %arg4, i64 %v
  store i32 %u.tr, i32* %par.v.ptr, align 4
  br label %v.cont

v.cont:
  %v.next = add i64 %v, 1
  br label %v.cond

after.inner:
  %t.next = add i64 %t, 1
  br label %outer.cond

do.free:
  %raw2 = bitcast i32* %block to i8*
  call void @free(i8* %raw2)
  br label %ret

ret:
  ret void
}