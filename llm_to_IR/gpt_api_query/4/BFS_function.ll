; ModuleID = 'bfs'
target triple = "x86_64-pc-linux-gnu"

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %out, i64* %outCount) {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  %start_ge_n = icmp uge i64 %start, %n
  %bad = or i1 %n_is_zero, %start_ge_n
  br i1 %bad, label %early, label %init_dist

early:
  store i64 0, i64* %outCount, align 8
  ret void

init_dist:
  br label %dist_loop

dist_loop:
  %i = phi i64 [ 0, %init_dist ], [ %inc, %dist_loop_body ]
  %cmp = icmp ult i64 %i, %n
  br i1 %cmp, label %dist_loop_body, label %after_dist

dist_loop_body:
  %dptr = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dptr, align 4
  %inc = add i64 %i, 1
  br label %dist_loop

after_dist:
  %size = shl i64 %n, 3
  %raw = call noalias i8* @malloc(i64 %size)
  %queue = bitcast i8* %raw to i64*
  %isnull = icmp eq i64* %queue, null
  br i1 %isnull, label %early, label %setup

setup:
  %dstart = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dstart, align 4
  %q0 = getelementptr inbounds i64, i64* %queue, i64 0
  store i64 %start, i64* %q0, align 8
  store i64 0, i64* %outCount, align 8
  br label %outer_loop

outer_loop:
  %head = phi i64 [ 0, %setup ], [ %head.next, %after_inner ]
  %tail = phi i64 [ 1, %setup ], [ %tail.final, %after_inner ]
  %cond = icmp ult i64 %head, %tail
  br i1 %cond, label %dequeue, label %done

dequeue:
  %qhead = getelementptr inbounds i64, i64* %queue, i64 %head
  %u = load i64, i64* %qhead, align 8
  %head.next = add i64 %head, 1
  %old = load i64, i64* %outCount, align 8
  %new = add i64 %old, 1
  store i64 %new, i64* %outCount, align 8
  %outptr = getelementptr inbounds i64, i64* %out, i64 %old
  store i64 %u, i64* %outptr, align 8
  br label %inner_loop

inner_loop:
  %j = phi i64 [ 0, %dequeue ], [ %j.next, %inner_body_end ]
  %tail.cur = phi i64 [ %tail, %dequeue ], [ %tail.next2, %inner_body_end ]
  %jcond = icmp ult i64 %j, %n
  br i1 %jcond, label %inner_body, label %after_inner

inner_body:
  %un = mul i64 %u, %n
  %idx = add i64 %un, %j
  %aptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %aval = load i32, i32* %aptr, align 4
  %edge_is_zero = icmp eq i32 %aval, 0
  br i1 %edge_is_zero, label %not_discover, label %check_undiscovered

check_undiscovered:
  %djptr = getelementptr inbounds i32, i32* %dist, i64 %j
  %dj = load i32, i32* %djptr, align 4
  %isNeg1 = icmp eq i32 %dj, -1
  br i1 %isNeg1, label %discover, label %not_discover

discover:
  %duptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %du = load i32, i32* %duptr, align 4
  %du1 = add i32 %du, 1
  store i32 %du1, i32* %djptr, align 4
  %qtail = getelementptr inbounds i64, i64* %queue, i64 %tail.cur
  store i64 %j, i64* %qtail, align 8
  %tail.enq = add i64 %tail.cur, 1
  br label %inner_body_end

not_discover:
  br label %inner_body_end

inner_body_end:
  %tail.next2 = phi i64 [ %tail.enq, %discover ], [ %tail.cur, %not_discover ]
  %j.next = add i64 %j, 1
  br label %inner_loop

after_inner:
  %tail.final = phi i64 [ %tail.cur, %inner_loop ]
  br label %outer_loop

done:
  %rawq = bitcast i64* %queue to i8*
  call void @free(i8* %rawq)
  ret void
}