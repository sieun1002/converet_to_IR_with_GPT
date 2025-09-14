; ModuleID = 'bfs'
declare noalias i8* @malloc(i64)
declare void @free(i8*)

define void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %out_order, i64* %out_count) {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  br i1 %n_is_zero, label %early, label %check_start

check_start:
  %start_ge_n = icmp uge i64 %start, %n
  br i1 %start_ge_n, label %early, label %init

early:
  store i64 0, i64* %out_count
  ret void

init:
  br label %init.loop

init.loop:
  %i = phi i64 [ 0, %init ], [ %i.next, %init.loop ]
  %cond = icmp ult i64 %i, %n
  br i1 %cond, label %init.loop.body, label %after.init

init.loop.body:
  %dist.ptr = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist.ptr
  %i.next = add i64 %i, 1
  br label %init.loop

after.init:
  %bytes = shl i64 %n, 3
  %q.i8 = call noalias i8* @malloc(i64 %bytes)
  %q.null = icmp eq i8* %q.i8, null
  br i1 %q.null, label %early, label %alloc.ok

alloc.ok:
  %q = bitcast i8* %q.i8 to i64*
  %head = alloca i64
  %tail = alloca i64
  store i64 0, i64* %head
  store i64 0, i64* %tail

  %dist.start.ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist.start.ptr

  %tail.val0 = load i64, i64* %tail
  %q.tail.ptr0 = getelementptr inbounds i64, i64* %q, i64 %tail.val0
  store i64 %start, i64* %q.tail.ptr0
  %tail.next0 = add i64 %tail.val0, 1
  store i64 %tail.next0, i64* %tail

  store i64 0, i64* %out_count

  br label %bfs.while

bfs.while:
  %head.cur = load i64, i64* %head
  %tail.cur = load i64, i64* %tail
  %not_empty = icmp ult i64 %head.cur, %tail.cur
  br i1 %not_empty, label %bfs.body, label %bfs.done

bfs.body:
  %q.head.ptr = getelementptr inbounds i64, i64* %q, i64 %head.cur
  %u = load i64, i64* %q.head.ptr
  %head.next = add i64 %head.cur, 1
  store i64 %head.next, i64* %head

  %cnt0 = load i64, i64* %out_count
  %out.ptr = getelementptr inbounds i64, i64* %out_order, i64 %cnt0
  store i64 %u, i64* %out.ptr
  %cnt1 = add i64 %cnt0, 1
  store i64 %cnt1, i64* %out_count

  br label %for.v

for.v:
  %v = phi i64 [ 0, %bfs.body ], [ %v.next, %for.v.end ]
  %v.cond = icmp ult i64 %v, %n
  br i1 %v.cond, label %for.v.body, label %bfs.while.cont

for.v.body:
  %un = mul i64 %u, %n
  %idxAdj = add i64 %un, %v
  %adj.ptr = getelementptr inbounds i32, i32* %adj, i64 %idxAdj
  %adj.val = load i32, i32* %adj.ptr
  %edge = icmp ne i32 %adj.val, 0
  br i1 %edge, label %check.unvisited, label %for.v.end

check.unvisited:
  %dist.v.ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %dist.v = load i32, i32* %dist.v.ptr
  %is.unvisited = icmp eq i32 %dist.v, -1
  br i1 %is.unvisited, label %visit.v, label %for.v.end

visit.v:
  %dist.u.ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %dist.u = load i32, i32* %dist.u.ptr
  %dist.u.plus1 = add i32 %dist.u, 1
  store i32 %dist.u.plus1, i32* %dist.v.ptr

  %tail.cur2 = load i64, i64* %tail
  %q.tail.ptr2 = getelementptr inbounds i64, i64* %q, i64 %tail.cur2
  store i64 %v, i64* %q.tail.ptr2
  %tail.next2 = add i64 %tail.cur2, 1
  store i64 %tail.next2, i64* %tail
  br label %for.v.end

for.v.end:
  %v.next = add i64 %v, 1
  br label %for.v

bfs.while.cont:
  br label %bfs.while

bfs.done:
  %q.i8.cast = bitcast i64* %q to i8*
  call void @free(i8* %q.i8.cast)
  ret void
}