; ModuleID = 'bfs_module'
target triple = "x86_64-unknown-linux-gnu"

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %out, i64* %out_count) {
entry:
  %head = alloca i64, align 8
  %tail = alloca i64, align 8
  %u = alloca i64, align 8
  %v = alloca i64, align 8

  ; validate inputs: n != 0 and start < n (unsigned)
  %valid_n = icmp ne i64 %n, 0
  %start_ok = icmp ult i64 %start, %n
  %ok = and i1 %valid_n, %start_ok
  br i1 %ok, label %init_loop, label %error

error:
  store i64 0, i64* %out_count, align 8
  ret void

init_loop:
  br label %init_loop.check

init_loop.check:
  %i = phi i64 [ 0, %init_loop ], [ %i.next, %init_loop.body ]
  %init_cond = icmp ult i64 %i, %n
  br i1 %init_cond, label %init_loop.body, label %alloc

init_loop.body:
  %dist_i_ptr = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist_i_ptr, align 4
  %i.next = add i64 %i, 1
  br label %init_loop.check

alloc:
  %size_bytes = shl i64 %n, 3
  %raw = call noalias i8* @malloc(i64 %size_bytes)
  %queue = bitcast i8* %raw to i64*
  %isnull = icmp eq i64* %queue, null
  br i1 %isnull, label %alloc_fail, label %enq_start

alloc_fail:
  store i64 0, i64* %out_count, align 8
  ret void

enq_start:
  store i64 0, i64* %head, align 8
  store i64 0, i64* %tail, align 8

  ; dist[start] = 0
  %dist_start_ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist_start_ptr, align 4

  ; enqueue start at tail
  %t0 = load i64, i64* %tail, align 8
  %qtailp0 = getelementptr inbounds i64, i64* %queue, i64 %t0
  store i64 %start, i64* %qtailp0, align 8
  %t1 = add i64 %t0, 1
  store i64 %t1, i64* %tail, align 8

  ; *out_count = 0
  store i64 0, i64* %out_count, align 8

  br label %loop.check

loop.check:
  %hcur = load i64, i64* %head, align 8
  %tcur = load i64, i64* %tail, align 8
  %has_items = icmp ult i64 %hcur, %tcur
  br i1 %has_items, label %loop.body, label %loop.exit

loop.body:
  ; dequeue
  %hcur2 = load i64, i64* %head, align 8
  %qhptr = getelementptr inbounds i64, i64* %queue, i64 %hcur2
  %uval = load i64, i64* %qhptr, align 8
  store i64 %uval, i64* %u, align 8
  %hnext = add i64 %hcur2, 1
  store i64 %hnext, i64* %head, align 8

  ; out[*out_count++] = u
  %oldc = load i64, i64* %out_count, align 8
  %newc = add i64 %oldc, 1
  store i64 %newc, i64* %out_count, align 8
  %out_slot = getelementptr inbounds i64, i64* %out, i64 %oldc
  store i64 %uval, i64* %out_slot, align 8

  ; for (v = 0; v < n; ++v)
  store i64 0, i64* %v, align 8
  br label %for.check

for.check:
  %vcur = load i64, i64* %v, align 8
  %vcond = icmp ult i64 %vcur, %n
  br i1 %vcond, label %for.body, label %loop.body_end

for.body:
  %u_cur = load i64, i64* %u, align 8
  %un_mul = mul i64 %u_cur, %n
  %idx = add i64 %un_mul, %vcur
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %a = load i32, i32* %adj_ptr, align 4
  %a_nonzero = icmp ne i32 %a, 0
  br i1 %a_nonzero, label %check_unvisited, label %inc_v

check_unvisited:
  %distv_ptr = getelementptr inbounds i32, i32* %dist, i64 %vcur
  %distv = load i32, i32* %distv_ptr, align 4
  %unvisited = icmp eq i32 %distv, -1
  br i1 %unvisited, label %visit, label %inc_v

visit:
  ; dist[v] = dist[u] + 1
  %distu_ptr = getelementptr inbounds i32, i32* %dist, i64 %u_cur
  %distu = load i32, i32* %distu_ptr, align 4
  %distu_plus1 = add i32 %distu, 1
  store i32 %distu_plus1, i32* %distv_ptr, align 4

  ; enqueue v
  %tq0 = load i64, i64* %tail, align 8
  %qtailp = getelementptr inbounds i64, i64* %queue, i64 %tq0
  store i64 %vcur, i64* %qtailp, align 8
  %tq1 = add i64 %tq0, 1
  store i64 %tq1, i64* %tail, align 8
  br label %inc_v

inc_v:
  %vnext = add i64 %vcur, 1
  store i64 %vnext, i64* %v, align 8
  br label %for.check

loop.body_end:
  br label %loop.check

loop.exit:
  %queue_i8 = bitcast i64* %queue to i8*
  call void @free(i8* %queue_i8)
  ret void
}