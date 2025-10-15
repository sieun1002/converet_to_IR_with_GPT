target triple = "x86_64-pc-windows-msvc"

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define void @dijkstra(i32* %arg0, i64 %arg8, i64 %arg10, i32* %arg18, i32* %arg20) {
entry:
  %cmp_n_zero = icmp eq i64 %arg8, 0
  br i1 %cmp_n_zero, label %end, label %check_src

check_src:
  %cmp_src = icmp uge i64 %arg10, %arg8
  br i1 %cmp_src, label %end, label %alloc

alloc:
  %size_bytes = shl i64 %arg8, 2
  %raw = call i8* @malloc(i64 %size_bytes)
  %isnull = icmp eq i8* %raw, null
  br i1 %isnull, label %end, label %postalloc

postalloc:
  %block = bitcast i8* %raw to i32*
  br label %init.cond

init.cond:
  %i = phi i64 [ 0, %postalloc ], [ %i.next, %init.body ]
  %init_cmp = icmp ult i64 %i, %arg8
  br i1 %init_cmp, label %init.body, label %init.after

init.body:
  %dist.elem.ptr = getelementptr inbounds i32, i32* %arg18, i64 %i
  store i32 1061109567, i32* %dist.elem.ptr, align 4
  %pred.elem.ptr = getelementptr inbounds i32, i32* %arg20, i64 %i
  store i32 -1, i32* %pred.elem.ptr, align 4
  %block.elem.ptr = getelementptr inbounds i32, i32* %block, i64 %i
  store i32 0, i32* %block.elem.ptr, align 4
  %i.next = add i64 %i, 1
  br label %init.cond

init.after:
  %dist.src.ptr = getelementptr inbounds i32, i32* %arg18, i64 %arg10
  store i32 0, i32* %dist.src.ptr, align 4
  br label %outer.cond

outer.cond:
  %iter = phi i64 [ 0, %init.after ], [ %iter.next, %outer.afterbody ]
  %outer_cmp = icmp ult i64 %iter, %arg8
  br i1 %outer_cmp, label %select.cond, label %freeblock

select.cond:
  %k = phi i64 [ 0, %outer.cond ], [ %k.next, %select.latch ]
  %u = phi i64 [ %arg8, %outer.cond ], [ %u.next, %select.latch ]
  %best = phi i32 [ 1061109567, %outer.cond ], [ %best.next, %select.latch ]
  %k_cmp = icmp ult i64 %k, %arg8
  br i1 %k_cmp, label %select.body, label %select.after

select.body:
  %blk.k.ptr = getelementptr inbounds i32, i32* %block, i64 %k
  %blk.k = load i32, i32* %blk.k.ptr, align 4
  %blk.k.zero = icmp eq i32 %blk.k, 0
  %dist.k.ptr = getelementptr inbounds i32, i32* %arg18, i64 %k
  %dist.k = load i32, i32* %dist.k.ptr, align 4
  %cmp_dist_best = icmp slt i32 %dist.k, %best
  %cond.update = and i1 %blk.k.zero, %cmp_dist_best
  %u.sel = select i1 %cond.update, i64 %k, i64 %u
  %best.sel = select i1 %cond.update, i32 %dist.k, i32 %best
  br label %select.latch

select.latch:
  %u.next = phi i64 [ %u.sel, %select.body ]
  %best.next = phi i32 [ %best.sel, %select.body ]
  %k.next = add i64 %k, 1
  br label %select.cond

select.after:
  %u_eq_n = icmp eq i64 %u, %arg8
  br i1 %u_eq_n, label %freeblock, label %visit_and_relax

visit_and_relax:
  %blk.u.ptr = getelementptr inbounds i32, i32* %block, i64 %u
  store i32 1, i32* %blk.u.ptr, align 4
  br label %j.cond

j.cond:
  %j = phi i64 [ 0, %visit_and_relax ], [ %j.next, %j.latch ]
  %j_cmp = icmp ult i64 %j, %arg8
  br i1 %j_cmp, label %j.body, label %outer.afterbody

j.body:
  %rowMul = mul i64 %u, %arg8
  %idx = add i64 %rowMul, %j
  %edge.ptr = getelementptr inbounds i32, i32* %arg0, i64 %idx
  %w = load i32, i32* %edge.ptr, align 4
  %w.neg = icmp slt i32 %w, 0
  br i1 %w.neg, label %j.latch, label %j.checkblk

j.checkblk:
  %blk.j.ptr = getelementptr inbounds i32, i32* %block, i64 %j
  %blk.j = load i32, i32* %blk.j.ptr, align 4
  %blk.j.zero = icmp eq i32 %blk.j, 0
  br i1 %blk.j.zero, label %j.checkdu, label %j.latch

j.checkdu:
  %dist.u.ptr = getelementptr inbounds i32, i32* %arg18, i64 %u
  %du = load i32, i32* %dist.u.ptr, align 4
  %du.isinf = icmp eq i32 %du, 1061109567
  br i1 %du.isinf, label %j.latch, label %j.new

j.new:
  %newd = add i32 %du, %w
  %dist.j.ptr = getelementptr inbounds i32, i32* %arg18, i64 %j
  %old = load i32, i32* %dist.j.ptr, align 4
  %cmp_new_old = icmp slt i32 %newd, %old
  br i1 %cmp_new_old, label %j.update, label %j.latch

j.update:
  store i32 %newd, i32* %dist.j.ptr, align 4
  %u.trunc = trunc i64 %u to i32
  %pred.j.ptr = getelementptr inbounds i32, i32* %arg20, i64 %j
  store i32 %u.trunc, i32* %pred.j.ptr, align 4
  br label %j.latch

j.latch:
  %j.next = add i64 %j, 1
  br label %j.cond

outer.afterbody:
  %iter.next = add i64 %iter, 1
  br label %outer.cond

freeblock:
  %block.i8 = bitcast i32* %block to i8*
  call void @free(i8* %block.i8)
  br label %end

end:
  ret void
}