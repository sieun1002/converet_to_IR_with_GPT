; ModuleID = 'bfs'
target triple = "x86_64-pc-windows-msvc"

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define void @bfs(i32* %adj, i64 %n, i64 %src, i32* %dist, i64* %out, i64* %outCount) {
entry:
  %cmpZero = icmp eq i64 %n, 0
  br i1 %cmpZero, label %early, label %checkSrc

early:
  store i64 0, i64* %outCount, align 8
  ret void

checkSrc:
  %cmpSrc = icmp ult i64 %src, %n
  br i1 %cmpSrc, label %initLoop, label %early2

early2:
  store i64 0, i64* %outCount, align 8
  ret void

initLoop:
  br label %initLoop.header

initLoop.header:
  %i.init = phi i64 [ 0, %initLoop ], [ %i.next, %initLoop.body ]
  %endCmp = icmp ult i64 %i.init, %n
  br i1 %endCmp, label %initLoop.body, label %postInit

initLoop.body:
  %gep.dist.i = getelementptr inbounds i32, i32* %dist, i64 %i.init
  store i32 -1, i32* %gep.dist.i, align 4
  %i.next = add i64 %i.init, 1
  br label %initLoop.header

postInit:
  %sizeBytes = shl i64 %n, 3
  %blk.raw = call noalias i8* @malloc(i64 %sizeBytes)
  %blk.null = icmp eq i8* %blk.raw, null
  br i1 %blk.null, label %early3, label %alloc.ok

early3:
  store i64 0, i64* %outCount, align 8
  ret void

alloc.ok:
  %blk = bitcast i8* %blk.raw to i64*
  %dist.src.ptr = getelementptr inbounds i32, i32* %dist, i64 %src
  store i32 0, i32* %dist.src.ptr, align 4
  %blk.tail.ptr0 = getelementptr inbounds i64, i64* %blk, i64 0
  store i64 %src, i64* %blk.tail.ptr0, align 8
  store i64 0, i64* %outCount, align 8
  br label %bfs.loop

bfs.loop:
  %head = phi i64 [ 0, %alloc.ok ], [ %head.next, %neigh.done ]
  %tail = phi i64 [ 1, %alloc.ok ], [ %tail.exit, %neigh.done ]
  %cond = icmp ult i64 %head, %tail
  br i1 %cond, label %dequeue, label %done

dequeue:
  %v.ptr = getelementptr inbounds i64, i64* %blk, i64 %head
  %v = load i64, i64* %v.ptr, align 8
  %head.next = add i64 %head, 1
  %oldCount = load i64, i64* %outCount, align 8
  %incCount = add i64 %oldCount, 1
  store i64 %incCount, i64* %outCount, align 8
  %out.slot = getelementptr inbounds i64, i64* %out, i64 %oldCount
  store i64 %v, i64* %out.slot, align 8
  br label %neigh.loop.header

neigh.loop.header:
  %i = phi i64 [ 0, %dequeue ], [ %i.next2, %neigh.loop.latch ]
  %tail.in = phi i64 [ %tail, %dequeue ], [ %tail.upd, %neigh.loop.latch ]
  %cmp.i = icmp ult i64 %i, %n
  br i1 %cmp.i, label %neigh.body, label %neigh.done

neigh.body:
  %mul = mul i64 %v, %n
  %idx = add i64 %mul, %i
  %adj.ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %val = load i32, i32* %adj.ptr, align 4
  %isZero = icmp eq i32 %val, 0
  br i1 %isZero, label %latch.skip, label %check_unvisited

check_unvisited:
  %dist.i.ptr = getelementptr inbounds i32, i32* %dist, i64 %i
  %di = load i32, i32* %dist.i.ptr, align 4
  %isNeg1 = icmp eq i32 %di, -1
  br i1 %isNeg1, label %enqueue_update, label %latch.skip

enqueue_update:
  %dist.v.ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %dv = load i32, i32* %dist.v.ptr, align 4
  %dvp1 = add i32 %dv, 1
  store i32 %dvp1, i32* %dist.i.ptr, align 4
  %blk.tail.ptr = getelementptr inbounds i64, i64* %blk, i64 %tail.in
  store i64 %i, i64* %blk.tail.ptr, align 8
  %tail.after = add i64 %tail.in, 1
  br label %neigh.loop.latch

latch.skip:
  br label %neigh.loop.latch

neigh.loop.latch:
  %tail.upd = phi i64 [ %tail.after, %enqueue_update ], [ %tail.in, %latch.skip ]
  %i.next2 = add i64 %i, 1
  br label %neigh.loop.header

neigh.done:
  %tail.exit = phi i64 [ %tail.in, %neigh.loop.header ]
  br label %bfs.loop

done:
  call void @free(i8* %blk.raw)
  ret void
}