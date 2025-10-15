; ModuleID = 'dijkstra.ll'
target triple = "x86_64-pc-windows-msvc"

declare dllimport i8* @malloc(i64)
declare dllimport void @free(i8*)

define dso_local void @dijkstra(i32* %graph, i64 %n, i64 %source, i32* %dist, i32* %prev) {
entry:
  %cmp_n0 = icmp eq i64 %n, 0
  br i1 %cmp_n0, label %ret, label %checksrc

checksrc:
  %cmp_src_ge = icmp uge i64 %source, %n
  br i1 %cmp_src_ge, label %ret, label %do_malloc

do_malloc:
  %size = shl i64 %n, 2
  %blkraw = call i8* @malloc(i64 %size)
  %blk = bitcast i8* %blkraw to i32*
  %isnull = icmp eq i32* %blk, null
  br i1 %isnull, label %ret, label %init.cond

init.cond:
  %i = phi i64 [ 0, %do_malloc ], [ %i.next, %init.body ]
  %cmp_i = icmp ult i64 %i, %n
  br i1 %cmp_i, label %init.body, label %after_init

init.body:
  %dist_i_ptr = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 1061109567, i32* %dist_i_ptr, align 4
  %prev_i_ptr = getelementptr inbounds i32, i32* %prev, i64 %i
  store i32 -1, i32* %prev_i_ptr, align 4
  %blk_i_ptr = getelementptr inbounds i32, i32* %blk, i64 %i
  store i32 0, i32* %blk_i_ptr, align 4
  %i.next = add i64 %i, 1
  br label %init.cond

after_init:
  %dist_src_ptr = getelementptr inbounds i32, i32* %dist, i64 %source
  store i32 0, i32* %dist_src_ptr, align 4
  br label %outer.cond

outer.cond:
  %t = phi i64 [ 0, %after_init ], [ %t.next, %outer.latch ]
  %cmp_t = icmp ult i64 %t, %n
  br i1 %cmp_t, label %find.init, label %free_block

find.init:
  br label %find.cond

find.cond:
  %j = phi i64 [ 0, %find.init ], [ %j.next, %find.body.latch ]
  %curBestDist = phi i32 [ 1061109567, %find.init ], [ %curBestDist.next, %find.body.latch ]
  %curBestIndex = phi i64 [ %n, %find.init ], [ %curBestIndex.next, %find.body.latch ]
  %cmp_j = icmp ult i64 %j, %n
  br i1 %cmp_j, label %find.body, label %find.exit

find.body:
  %blk_j_ptr = getelementptr inbounds i32, i32* %blk, i64 %j
  %blk_j = load i32, i32* %blk_j_ptr, align 4
  %is_unvisited = icmp eq i32 %blk_j, 0
  br i1 %is_unvisited, label %find.checkdist, label %find.body.latch

find.checkdist:
  %dist_j_ptr = getelementptr inbounds i32, i32* %dist, i64 %j
  %dist_j = load i32, i32* %dist_j_ptr, align 4
  %cmp_better = icmp sgt i32 %curBestDist, %dist_j
  br i1 %cmp_better, label %find.update, label %find.body.latch

find.update:
  br label %find.body.latch

find.body.latch:
  %curBestDist.next = phi i32 [ %dist_j, %find.update ], [ %curBestDist, %find.body ], [ %curBestDist, %find.checkdist ]
  %curBestIndex.next = phi i64 [ %j, %find.update ], [ %curBestIndex, %find.body ], [ %curBestIndex, %find.checkdist ]
  %j.next = add i64 %j, 1
  br label %find.cond

find.exit:
  %bestIsN = icmp eq i64 %curBestIndex, %n
  br i1 %bestIsN, label %free_block, label %visit_and_relax

visit_and_relax:
  %blk_best_ptr = getelementptr inbounds i32, i32* %blk, i64 %curBestIndex
  store i32 1, i32* %blk_best_ptr, align 4
  br label %inner.cond

inner.cond:
  %k = phi i64 [ 0, %visit_and_relax ], [ %k.next, %inner.latch ]
  %cmp_k = icmp ult i64 %k, %n
  br i1 %cmp_k, label %inner.body.pre, label %outer.latch

inner.body.pre:
  %mul = mul i64 %curBestIndex, %n
  %sum = add i64 %mul, %k
  %gptr = getelementptr inbounds i32, i32* %graph, i64 %sum
  %weight = load i32, i32* %gptr, align 4
  %neg = icmp slt i32 %weight, 0
  br i1 %neg, label %inner.latch, label %inner.check.visited

inner.check.visited:
  %blk_k_ptr = getelementptr inbounds i32, i32* %blk, i64 %k
  %blk_k = load i32, i32* %blk_k_ptr, align 4
  %is_k_unvisited = icmp eq i32 %blk_k, 0
  br i1 %is_k_unvisited, label %inner.check.distKnown, label %inner.latch

inner.check.distKnown:
  %dist_best_ptr = getelementptr inbounds i32, i32* %dist, i64 %curBestIndex
  %dist_best = load i32, i32* %dist_best_ptr, align 4
  %is_inf = icmp eq i32 %dist_best, 1061109567
  br i1 %is_inf, label %inner.latch, label %inner.relax.check

inner.relax.check:
  %newDist = add i32 %dist_best, %weight
  %dist_k_ptr = getelementptr inbounds i32, i32* %dist, i64 %k
  %dist_k = load i32, i32* %dist_k_ptr, align 4
  %cmp_ge = icmp sge i32 %newDist, %dist_k
  br i1 %cmp_ge, label %inner.latch, label %inner.relax.apply

inner.relax.apply:
  store i32 %newDist, i32* %dist_k_ptr, align 4
  %prev_k_ptr = getelementptr inbounds i32, i32* %prev, i64 %k
  %bestIndex32 = trunc i64 %curBestIndex to i32
  store i32 %bestIndex32, i32* %prev_k_ptr, align 4
  br label %inner.latch

inner.latch:
  %k.next = add i64 %k, 1
  br label %inner.cond

outer.latch:
  %t.next = add i64 %t, 1
  br label %outer.cond

free_block:
  %blk_to_i8 = bitcast i32* %blk to i8*
  call void @free(i8* %blk_to_i8)
  br label %ret

ret:
  ret void
}