; ModuleID = 'bfs_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

declare dllimport i8* @malloc(i64)
declare dllimport void @free(i8*)

define void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %out_order, i64* %out_count) {
entry:
  %cmp_n_zero = icmp eq i64 %n, 0
  %cmp_start_oob = icmp uge i64 %start, %n
  %bad = or i1 %cmp_n_zero, %cmp_start_oob
  br i1 %bad, label %early, label %init

early:
  store i64 0, i64* %out_count, align 8
  ret void

init:
  br label %dist.loop

dist.loop:
  %i = phi i64 [ 0, %init ], [ %i.next, %dist.body ]
  %i.cmp = icmp ult i64 %i, %n
  br i1 %i.cmp, label %dist.body, label %post.initdist

dist.body:
  %dist.gep = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist.gep, align 4
  %i.next = add i64 %i, 1
  br label %dist.loop

post.initdist:
  %size.bytes = shl i64 %n, 3
  %q.raw = call i8* @malloc(i64 %size.bytes)
  %q.null = icmp eq i8* %q.raw, null
  br i1 %q.null, label %malloc.fail, label %malloc.ok

malloc.fail:
  store i64 0, i64* %out_count, align 8
  ret void

malloc.ok:
  %queue = bitcast i8* %q.raw to i64*
  %dstart.ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dstart.ptr, align 4
  %q0.ptr = getelementptr inbounds i64, i64* %queue, i64 0
  store i64 %start, i64* %q0.ptr, align 8
  store i64 0, i64* %out_count, align 8
  br label %bfs.check

bfs.check:
  %head = phi i64 [ 0, %malloc.ok ], [ %head.next, %after.inner ]
  %tail = phi i64 [ 1, %malloc.ok ], [ %tail.out, %after.inner ]
  %has_items = icmp ult i64 %head, %tail
  br i1 %has_items, label %dequeue, label %free.block

dequeue:
  %q.head.ptr = getelementptr inbounds i64, i64* %queue, i64 %head
  %u = load i64, i64* %q.head.ptr, align 8
  %head.next = add i64 %head, 1
  %oldc = load i64, i64* %out_count, align 8
  %newc = add i64 %oldc, 1
  store i64 %newc, i64* %out_count, align 8
  %out.idx.ptr = getelementptr inbounds i64, i64* %out_order, i64 %oldc
  store i64 %u, i64* %out.idx.ptr, align 8
  br label %v.loop

v.loop:
  %v = phi i64 [ 0, %dequeue ], [ %v.next, %v.inc ]
  %tail.loop = phi i64 [ %tail, %dequeue ], [ %tail.after, %v.inc ]
  %v.cmp = icmp ult i64 %v, %n
  br i1 %v.cmp, label %v.body, label %after.inner

v.body:
  %mul = mul i64 %u, %n
  %idx = add i64 %mul, %v
  %adj.ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %aval = load i32, i32* %adj.ptr, align 4
  %has_edge = icmp ne i32 %aval, 0
  %dv.ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %dv = load i32, i32* %dv.ptr, align 4
  %unseen = icmp eq i32 %dv, -1
  %go = and i1 %has_edge, %unseen
  br i1 %go, label %v.do, label %v.skip

v.do:
  %du.ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %du = load i32, i32* %du.ptr, align 4
  %dup1 = add i32 %du, 1
  store i32 %dup1, i32* %dv.ptr, align 4
  %q.tail.ptr = getelementptr inbounds i64, i64* %queue, i64 %tail.loop
  store i64 %v, i64* %q.tail.ptr, align 8
  %tail.new = add i64 %tail.loop, 1
  br label %v.inc

v.skip:
  br label %v.inc

v.inc:
  %tail.after = phi i64 [ %tail.new, %v.do ], [ %tail.loop, %v.skip ]
  %v.next = add i64 %v, 1
  br label %v.loop

after.inner:
  %tail.out = phi i64 [ %tail.loop, %v.loop ]
  br label %bfs.check

free.block:
  call void @free(i8* %q.raw)
  ret void
}