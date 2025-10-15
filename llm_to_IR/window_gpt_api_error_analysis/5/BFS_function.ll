; ModuleID = 'bfs_module'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare dllimport i8* @malloc(i64)
declare dllimport void @free(i8*)

define void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %order, i64* %outCount) {
entry:
  %cmp.n.zero = icmp eq i64 %n, 0
  %cmp.start.ge.n = icmp uge i64 %start, %n
  %bad.input = or i1 %cmp.n.zero, %cmp.start.ge.n
  br i1 %bad.input, label %early, label %init.loop

early:
  store i64 0, i64* %outCount, align 8
  ret void

init.loop:
  %i.init = phi i64 [ 0, %entry ], [ %i.next, %init.cont ]
  %cond.init = icmp ult i64 %i.init, %n
  br i1 %cond.init, label %init.body, label %alloc

init.body:
  %dist.ptr = getelementptr inbounds i32, i32* %dist, i64 %i.init
  store i32 -1, i32* %dist.ptr, align 4
  br label %init.cont

init.cont:
  %i.next = add i64 %i.init, 1
  br label %init.loop

alloc:
  %size.bytes = shl i64 %n, 3
  %malloc.ptr = call i8* @malloc(i64 %size.bytes)
  %queue = bitcast i8* %malloc.ptr to i64*
  %malloc.null = icmp eq i8* %malloc.ptr, null
  br i1 %malloc.null, label %malloc_fail, label %init.queue

malloc_fail:
  store i64 0, i64* %outCount, align 8
  ret void

init.queue:
  %start.dist.ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %start.dist.ptr, align 4
  %q0 = getelementptr inbounds i64, i64* %queue, i64 0
  store i64 %start, i64* %q0, align 8
  store i64 0, i64* %outCount, align 8
  br label %while

while:
  %head = phi i64 [ 0, %init.queue ], [ %head.next, %afterNeighbors ]
  %tail = phi i64 [ 1, %init.queue ], [ %tail.after, %afterNeighbors ]
  %cond.q = icmp ult i64 %head, %tail
  br i1 %cond.q, label %dequeue, label %done

dequeue:
  %v.ptr = getelementptr inbounds i64, i64* %queue, i64 %head
  %v = load i64, i64* %v.ptr, align 8
  %head.next = add i64 %head, 1
  %t.old = load i64, i64* %outCount, align 8
  %t.new = add i64 %t.old, 1
  store i64 %t.new, i64* %outCount, align 8
  %order.slot = getelementptr inbounds i64, i64* %order, i64 %t.old
  store i64 %v, i64* %order.slot, align 8
  br label %forN

forN:
  %u = phi i64 [ 0, %dequeue ], [ %u.next, %forN.cont ]
  %tail.cur = phi i64 [ %tail, %dequeue ], [ %tail.next, %forN.cont ]
  %u.lt.n = icmp ult i64 %u, %n
  br i1 %u.lt.n, label %checkEdge, label %afterNeighbors

checkEdge:
  %mul.vn = mul i64 %v, %n
  %idx = add i64 %mul.vn, %u
  %adj.ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %a.val = load i32, i32* %adj.ptr, align 4
  %edge.nz = icmp ne i32 %a.val, 0
  br i1 %edge.nz, label %checkUnvisited, label %forN.cont

checkUnvisited:
  %du.ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %du.val = load i32, i32* %du.ptr, align 4
  %is.unvisited = icmp eq i32 %du.val, -1
  br i1 %is.unvisited, label %visit, label %forN.cont

visit:
  %dv.ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %dv.val = load i32, i32* %dv.ptr, align 4
  %dv.plus1 = add i32 %dv.val, 1
  store i32 %dv.plus1, i32* %du.ptr, align 4
  %q.enq.ptr = getelementptr inbounds i64, i64* %queue, i64 %tail.cur
  store i64 %u, i64* %q.enq.ptr, align 8
  %tail.enq = add i64 %tail.cur, 1
  br label %forN.cont

forN.cont:
  %tail.next = phi i64 [ %tail.cur, %checkEdge ], [ %tail.cur, %checkUnvisited ], [ %tail.enq, %visit ]
  %u.next = add i64 %u, 1
  br label %forN

afterNeighbors:
  %tail.after = phi i64 [ %tail.cur, %forN ]
  br label %while

done:
  call void @free(i8* %malloc.ptr)
  ret void
}