; target: x86_64 SysV ABI, LLVM 14
target triple = "x86_64-pc-linux-gnu"

declare noalias i8* @malloc(i64)
declare void @free(i8* nocapture)

define void @dfs(i32* nocapture readonly %adj, i64 %n, i64 %start, i64* nocapture %out, i64* nocapture %out_len) local_unnamed_addr {
entry:
  %cmp.n.zero = icmp eq i64 %n, 0
  %cmp.start.oob = icmp uge i64 %start, %n
  %bad = or i1 %cmp.n.zero, %cmp.start.oob
  br i1 %bad, label %early, label %alloc

early:
  store i64 0, i64* %out_len, align 8
  ret void

alloc:
  %size.vis = shl nuw i64 %n, 2
  %p.vis.raw = call noalias i8* @malloc(i64 %size.vis)
  %visited = bitcast i8* %p.vis.raw to i32*
  %size.i64 = shl nuw i64 %n, 3
  %p.next.raw = call noalias i8* @malloc(i64 %size.i64)
  %next = bitcast i8* %p.next.raw to i64*
  %p.stack.raw = call noalias i8* @malloc(i64 %size.i64)
  %stack = bitcast i8* %p.stack.raw to i64*
  %isnull.vis = icmp eq i8* %p.vis.raw, null
  %isnull.next = icmp eq i8* %p.next.raw, null
  %isnull.stack = icmp eq i8* %p.stack.raw, null
  %anynull.a = or i1 %isnull.vis, %isnull.next
  %anynull = or i1 %anynull.a, %isnull.stack
  br i1 %anynull, label %alloc_fail, label %init

alloc_fail:
  call void @free(i8* %p.vis.raw)
  call void @free(i8* %p.next.raw)
  call void @free(i8* %p.stack.raw)
  store i64 0, i64* %out_len, align 8
  ret void

init:
  br label %init.loop

init.loop:
  %i = phi i64 [ 0, %init ], [ %i.next, %init.body.end ]
  %cond.init = icmp ult i64 %i, %n
  br i1 %cond.init, label %init.body, label %init.done

init.body:
  %vis.ptr = getelementptr inbounds i32, i32* %visited, i64 %i
  store i32 0, i32* %vis.ptr, align 4
  %next.ptr = getelementptr inbounds i64, i64* %next, i64 %i
  store i64 0, i64* %next.ptr, align 8
  br label %init.body.end

init.body.end:
  %i.next = add nuw nsw i64 %i, 1
  br label %init.loop

init.done:
  store i64 0, i64* %out_len, align 8
  %stack.0.ptr = getelementptr inbounds i64, i64* %stack, i64 0
  store i64 %start, i64* %stack.0.ptr, align 8
  %vstart.ptr = getelementptr inbounds i32, i32* %visited, i64 %start
  store i32 1, i32* %vstart.ptr, align 4
  %len0 = load i64, i64* %out_len, align 8
  %out.slot0 = getelementptr inbounds i64, i64* %out, i64 %len0
  store i64 %start, i64* %out.slot0, align 8
  %len1 = add nuw nsw i64 %len0, 1
  store i64 %len1, i64* %out_len, align 8
  br label %check

check:
  %top = phi i64 [ 1, %init.done ], [ %top.next, %iter.end ]
  %has.items = icmp ne i64 %top, 0
  br i1 %has.items, label %iter.start, label %cleanup

iter.start:
  %topm1 = add nsw i64 %top, -1
  %stack.top.ptr = getelementptr inbounds i64, i64* %stack, i64 %topm1
  %u = load i64, i64* %stack.top.ptr, align 8
  %next.u.ptr = getelementptr inbounds i64, i64* %next, i64 %u
  %next.idx0 = load i64, i64* %next.u.ptr, align 8
  br label %nbr.loop

nbr.loop:
  %next.idx = phi i64 [ %next.idx0, %iter.start ], [ %next.idx.inc, %nbr.inc ]
  %has.nbr = icmp ult i64 %next.idx, %n
  br i1 %has.nbr, label %check.edge, label %nbr.done

check.edge:
  %mul.un = mul nuw nsw i64 %u, %n
  %lin = add i64 %mul.un, %next.idx
  %adj.ptr = getelementptr inbounds i32, i32* %adj, i64 %lin
  %adj.val = load i32, i32* %adj.ptr, align 4
  %edge.nz = icmp ne i32 %adj.val, 0
  br i1 %edge.nz, label %check.vis, label %nbr.inc

check.vis:
  %vis.n.ptr = getelementptr inbounds i32, i32* %visited, i64 %next.idx
  %vis.n = load i32, i32* %vis.n.ptr, align 4
  %vis.zero = icmp eq i32 %vis.n, 0
  br i1 %vis.zero, label %take.edge, label %nbr.inc

take.edge:
  %next.idx.p1 = add nuw nsw i64 %next.idx, 1
  store i64 %next.idx.p1, i64* %next.u.ptr, align 8
  store i32 1, i32* %vis.n.ptr, align 4
  %len2 = load i64, i64* %out_len, align 8
  %out.slot1 = getelementptr inbounds i64, i64* %out, i64 %len2
  store i64 %next.idx, i64* %out.slot1, align 8
  %len3 = add nuw nsw i64 %len2, 1
  store i64 %len3, i64* %out_len, align 8
  %stack.push.ptr = getelementptr inbounds i64, i64* %stack, i64 %top
  store i64 %next.idx, i64* %stack.push.ptr, align 8
  %top.after.push = add nuw nsw i64 %top, 1
  br label %iter.end.from.push

nbr.inc:
  %next.idx.inc = add nuw nsw i64 %next.idx, 1
  br label %nbr.loop

nbr.done:
  %top.pop = add nsw i64 %top, -1
  br label %iter.end

iter.end.from.push:
  br label %iter.end

iter.end:
  %top.next = phi i64 [ %top.after.push, %iter.end.from.push ], [ %top.pop, %nbr.done ]
  br label %check

cleanup:
  call void @free(i8* %p.vis.raw)
  call void @free(i8* %p.next.raw)
  call void @free(i8* %p.stack.raw)
  ret void
}