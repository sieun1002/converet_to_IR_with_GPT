; ModuleID = 'dijkstra'
target triple = "x86_64-pc-windows-msvc"

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define void @dijkstra(i32* %graph, i64 %n, i64 %src, i32* %dist, i32* %prev) {
entry:
  %cmp.n.zero = icmp eq i64 %n, 0
  br i1 %cmp.n.zero, label %end, label %check_src

check_src:
  %cmp.src.ge.n = icmp uge i64 %src, %n
  br i1 %cmp.src.ge.n, label %end, label %alloc

alloc:
  %size = shl i64 %n, 2
  %raw = call i8* @malloc(i64 %size)
  %isnull = icmp eq i8* %raw, null
  br i1 %isnull, label %end, label %init

init:
  %block = bitcast i8* %raw to i32*
  br label %init.loop

init.loop:
  %i = phi i64 [ 0, %init ], [ %i.next, %init.inc ]
  %i.lt.n = icmp ult i64 %i, %n
  br i1 %i.lt.n, label %init.body, label %post.init

init.body:
  %dist.i.ptr = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 1061109567, i32* %dist.i.ptr, align 4
  %prev.i.ptr = getelementptr inbounds i32, i32* %prev, i64 %i
  store i32 -1, i32* %prev.i.ptr, align 4
  %block.i.ptr = getelementptr inbounds i32, i32* %block, i64 %i
  store i32 0, i32* %block.i.ptr, align 4
  br label %init.inc

init.inc:
  %i.next = add i64 %i, 1
  br label %init.loop

post.init:
  %dist.src.ptr = getelementptr inbounds i32, i32* %dist, i64 %src
  store i32 0, i32* %dist.src.ptr, align 4
  br label %outer.loop

outer.loop:
  %k = phi i64 [ 0, %post.init ], [ %k.next, %outer.inc ]
  %k.lt.n = icmp ult i64 %k, %n
  br i1 %k.lt.n, label %select.init, label %cleanup

select.init:
  br label %select.loop

select.loop:
  %j = phi i64 [ 0, %select.init ], [ %j.next, %select.inc ]
  %minIdx = phi i64 [ %n, %select.init ], [ %minIdx.next, %select.inc ]
  %minDist = phi i32 [ 1061109567, %select.init ], [ %minDist.next, %select.inc ]
  %j.lt.n = icmp ult i64 %j, %n
  br i1 %j.lt.n, label %select.body, label %after.select

select.body:
  %blk.j.ptr = getelementptr inbounds i32, i32* %block, i64 %j
  %blk.j = load i32, i32* %blk.j.ptr, align 4
  %blk.is.zero = icmp eq i32 %blk.j, 0
  br i1 %blk.is.zero, label %check.dist, label %select.inc

check.dist:
  %dist.j.ptr = getelementptr inbounds i32, i32* %dist, i64 %j
  %dist.j = load i32, i32* %dist.j.ptr, align 4
  %min.le.distj = icmp sle i32 %minDist, %dist.j
  br i1 %min.le.distj, label %select.inc, label %update.min

update.min:
  br label %select.inc

select.inc:
  %minDist.next = phi i32 [ %minDist, %select.body ], [ %minDist, %check.dist ], [ %dist.j, %update.min ]
  %minIdx.next = phi i64 [ %minIdx, %select.body ], [ %minIdx, %check.dist ], [ %j, %update.min ]
  %j.next = add i64 %j, 1
  br label %select.loop

after.select:
  %minIdx.fin = phi i64 [ %minIdx, %select.loop ]
  %min.is.n = icmp eq i64 %minIdx.fin, %n
  br i1 %min.is.n, label %cleanup, label %mark.visited

mark.visited:
  %blk.min.ptr = getelementptr inbounds i32, i32* %block, i64 %minIdx.fin
  store i32 1, i32* %blk.min.ptr, align 4
  br label %relax.loop

relax.loop:
  %j2 = phi i64 [ 0, %mark.visited ], [ %j2.next, %relax.inc ]
  %j2.lt.n = icmp ult i64 %j2, %n
  br i1 %j2.lt.n, label %relax.body, label %outer.inc

relax.body:
  %mul = mul i64 %minIdx.fin, %n
  %sum = add i64 %mul, %j2
  %w.ptr = getelementptr inbounds i32, i32* %graph, i64 %sum
  %w = load i32, i32* %w.ptr, align 4
  %w.neg = icmp slt i32 %w, 0
  br i1 %w.neg, label %relax.inc, label %check.block.j2

check.block.j2:
  %blk.j2.ptr = getelementptr inbounds i32, i32* %block, i64 %j2
  %blk.j2 = load i32, i32* %blk.j2.ptr, align 4
  %blk.j2.nz = icmp ne i32 %blk.j2, 0
  br i1 %blk.j2.nz, label %relax.inc, label %check.min.inf

check.min.inf:
  %dist.min.ptr = getelementptr inbounds i32, i32* %dist, i64 %minIdx.fin
  %dist.min = load i32, i32* %dist.min.ptr, align 4
  %is.inf = icmp eq i32 %dist.min, 1061109567
  br i1 %is.inf, label %relax.inc, label %compute.new

compute.new:
  %new = add i32 %dist.min, %w
  %dist.j2.ptr = getelementptr inbounds i32, i32* %dist, i64 %j2
  %dist.j2 = load i32, i32* %dist.j2.ptr, align 4
  %new.ge.distj2 = icmp sge i32 %new, %dist.j2
  br i1 %new.ge.distj2, label %relax.inc, label %do.update

do.update:
  store i32 %new, i32* %dist.j2.ptr, align 4
  %minIdx.tr = trunc i64 %minIdx.fin to i32
  %prev.j2.ptr = getelementptr inbounds i32, i32* %prev, i64 %j2
  store i32 %minIdx.tr, i32* %prev.j2.ptr, align 4
  br label %relax.inc

relax.inc:
  %j2.next = add i64 %j2, 1
  br label %relax.loop

outer.inc:
  %k.next = add i64 %k, 1
  br label %outer.loop

cleanup:
  %block.i8 = bitcast i32* %block to i8*
  call void @free(i8* %block.i8)
  br label %end

end:
  ret void
}