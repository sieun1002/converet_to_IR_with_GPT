; ModuleID = 'bfs'
target triple = "x86_64-pc-windows-msvc"

declare i8* @malloc(i64)
declare void @free(i8*)

define void @bfs(i32* %arg0, i64 %arg1, i64 %arg2, i32* %arg3, i64* %arg4, i64* %arg5) {
entry:
  %cmp.zero = icmp eq i64 %arg1, 0
  br i1 %cmp.zero, label %early_zero, label %check_start

check_start:
  %cmp.inrange = icmp ult i64 %arg2, %arg1
  br i1 %cmp.inrange, label %init_dist.preheader, label %early_zero

early_zero:
  store i64 0, i64* %arg5, align 8
  br label %ret

init_dist.preheader:
  br label %init_dist.header

init_dist.header:
  %i.phi = phi i64 [0, %init_dist.preheader], [%i.next, %init_dist.body]
  %cmp.loop = icmp ult i64 %i.phi, %arg1
  br i1 %cmp.loop, label %init_dist.body, label %post_init

init_dist.body:
  %dist.ptr = getelementptr inbounds i32, i32* %arg3, i64 %i.phi
  store i32 -1, i32* %dist.ptr, align 4
  %i.next = add i64 %i.phi, 1
  br label %init_dist.header

post_init:
  %size.shl = shl i64 %arg1, 3
  %malloc.ptr = call i8* @malloc(i64 %size.shl)
  %block.ptr = bitcast i8* %malloc.ptr to i64*
  %isnull = icmp eq i8* %malloc.ptr, null
  br i1 %isnull, label %malloc_fail, label %init_queue

malloc_fail:
  store i64 0, i64* %arg5, align 8
  br label %ret

init_queue:
  %dist.start.ptr = getelementptr inbounds i32, i32* %arg3, i64 %arg2
  store i32 0, i32* %dist.start.ptr, align 4
  %queue.slot0 = getelementptr inbounds i64, i64* %block.ptr, i64 0
  store i64 %arg2, i64* %queue.slot0, align 8
  store i64 0, i64* %arg5, align 8
  br label %bfs.header

bfs.header:
  %head.phi = phi i64 [0, %init_queue], [%head.next, %bfs.inner.done]
  %tail.phi = phi i64 [1, %init_queue], [%tail.updated, %bfs.inner.done]
  %cmp.ht = icmp ult i64 %head.phi, %tail.phi
  br i1 %cmp.ht, label %dequeue, label %free_block

dequeue:
  %q.read.ptr = getelementptr inbounds i64, i64* %block.ptr, i64 %head.phi
  %curr.node = load i64, i64* %q.read.ptr, align 8
  %head.next = add i64 %head.phi, 1
  %count.old = load i64, i64* %arg5, align 8
  %count.new = add i64 %count.old, 1
  store i64 %count.new, i64* %arg5, align 8
  %order.slot = getelementptr inbounds i64, i64* %arg4, i64 %count.old
  store i64 %curr.node, i64* %order.slot, align 8
  br label %neighbors.header

neighbors.header:
  %j.phi = phi i64 [0, %dequeue], [%j.next, %neighbors.inc]
  %tail.loop = phi i64 [%tail.phi, %dequeue], [%tail.after, %neighbors.inc]
  %cmp.j = icmp ult i64 %j.phi, %arg1
  br i1 %cmp.j, label %neighbors.body, label %bfs.inner.done

neighbors.body:
  %mul.idx = mul i64 %curr.node, %arg1
  %mat.index = add i64 %mul.idx, %j.phi
  %mat.ptr = getelementptr inbounds i32, i32* %arg0, i64 %mat.index
  %edge.val = load i32, i32* %mat.ptr, align 4
  %edge.zero = icmp eq i32 %edge.val, 0
  br i1 %edge.zero, label %neighbors.inc, label %check.dist

check.dist:
  %dist.j.ptr = getelementptr inbounds i32, i32* %arg3, i64 %j.phi
  %dist.j = load i32, i32* %dist.j.ptr, align 4
  %is.unvisited = icmp eq i32 %dist.j, -1
  br i1 %is.unvisited, label %enqueue, label %neighbors.inc

enqueue:
  %dist.curr.ptr = getelementptr inbounds i32, i32* %arg3, i64 %curr.node
  %dist.curr = load i32, i32* %dist.curr.ptr, align 4
  %dist.next = add i32 %dist.curr, 1
  store i32 %dist.next, i32* %dist.j.ptr, align 4
  %q.tail.slot = getelementptr inbounds i64, i64* %block.ptr, i64 %tail.loop
  store i64 %j.phi, i64* %q.tail.slot, align 8
  %tail.enq = add i64 %tail.loop, 1
  br label %neighbors.inc

neighbors.inc:
  %tail.after = phi i64 [%tail.loop, %neighbors.body], [%tail.loop, %check.dist], [%tail.enq, %enqueue]
  %j.next = add i64 %j.phi, 1
  br label %neighbors.header

bfs.inner.done:
  %tail.updated = phi i64 [%tail.loop, %neighbors.header]
  br label %bfs.header

free_block:
  %block.i8 = bitcast i64* %block.ptr to i8*
  call void @free(i8* %block.i8)
  br label %ret

ret:
  ret void
}