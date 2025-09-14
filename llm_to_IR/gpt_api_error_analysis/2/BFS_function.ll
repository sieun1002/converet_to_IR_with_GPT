; ModuleID = 'bfs_module'
target triple = "x86_64-pc-linux-gnu"

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define dso_local void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %out, i64* %count) {
entry:
  %head = alloca i64, align 8
  %tail = alloca i64, align 8
  %qptr = alloca i64*, align 8
  %n_is_zero = icmp eq i64 %n, 0
  br i1 %n_is_zero, label %zero_ret, label %check_bounds

check_bounds:
  %start_lt_n = icmp ult i64 %start, %n
  br i1 %start_lt_n, label %init_dist, label %zero_ret

zero_ret:
  store i64 0, i64* %count, align 8
  ret void

init_dist:
  br label %init_loop

init_loop:
  %i = phi i64 [ 0, %init_dist ], [ %i.next, %init_loop_body ]
  %cmp = icmp ult i64 %i, %n
  br i1 %cmp, label %init_loop_body, label %alloc_queue

init_loop_body:
  %elem_ptr = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %elem_ptr, align 4
  %i.next = add i64 %i, 1
  br label %init_loop

alloc_queue:
  %size_bytes = shl i64 %n, 3
  %mem = call noalias i8* @malloc(i64 %size_bytes)
  %q = bitcast i8* %mem to i64*
  %isnull = icmp eq i8* %mem, null
  br i1 %isnull, label %zero_ret, label %setup

setup:
  store i64 0, i64* %head, align 8
  store i64 0, i64* %tail, align 8
  store i64* %q, i64** %qptr, align 8
  %start_ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %start_ptr, align 4
  %tail0 = load i64, i64* %tail, align 8
  %q_loaded = load i64*, i64** %qptr, align 8
  %slot_ptr = getelementptr inbounds i64, i64* %q_loaded, i64 %tail0
  store i64 %start, i64* %slot_ptr, align 8
  %tail1 = add i64 %tail0, 1
  store i64 %tail1, i64* %tail, align 8
  store i64 0, i64* %count, align 8
  br label %outer_while

outer_while:
  %headv = load i64, i64* %head, align 8
  %tailv = load i64, i64* %tail, align 8
  %cond = icmp ult i64 %headv, %tailv
  br i1 %cond, label %dequeue, label %done

dequeue:
  %q_loaded2 = load i64*, i64** %qptr, align 8
  %slot_ptr2 = getelementptr inbounds i64, i64* %q_loaded2, i64 %headv
  %u = load i64, i64* %slot_ptr2, align 8
  %head_next = add i64 %headv, 1
  store i64 %head_next, i64* %head, align 8
  %oldcount = load i64, i64* %count, align 8
  %newcount = add i64 %oldcount, 1
  store i64 %newcount, i64* %count, align 8
  %out_slot = getelementptr inbounds i64, i64* %out, i64 %oldcount
  store i64 %u, i64* %out_slot, align 8
  br label %for_v

for_v:
  %v = phi i64 [ 0, %dequeue ], [ %v.next, %for_v_body ]
  %vcond = icmp ult i64 %v, %n
  br i1 %vcond, label %for_v_body, label %outer_while

for_v_body:
  %un = mul i64 %u, %n
  %idx = add i64 %un, %v
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %a = load i32, i32* %adj_ptr, align 4
  %has_edge = icmp ne i32 %a, 0
  br i1 %has_edge, label %check_unvisited, label %inc_v

check_unvisited:
  %dist_v_ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %d_v = load i32, i32* %dist_v_ptr, align 4
  %is_unvisited = icmp eq i32 %d_v, -1
  br i1 %is_unvisited, label %visit, label %inc_v

visit:
  %dist_u_ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %d_u = load i32, i32* %dist_u_ptr, align 4
  %d_u_plus1 = add nsw i32 %d_u, 1
  store i32 %d_u_plus1, i32* %dist_v_ptr, align 4
  %tailv2 = load i64, i64* %tail, align 8
  %q_loaded3 = load i64*, i64** %qptr, align 8
  %slot_ptr3 = getelementptr inbounds i64, i64* %q_loaded3, i64 %tailv2
  store i64 %v, i64* %slot_ptr3, align 8
  %tail_next = add i64 %tailv2, 1
  store i64 %tail_next, i64* %tail, align 8
  br label %inc_v

inc_v:
  %v.next = add i64 %v, 1
  br label %for_v

done:
  %q_loaded4 = load i64*, i64** %qptr, align 8
  %q_i8 = bitcast i64* %q_loaded4 to i8*
  call void @free(i8* %q_i8)
  ret void
}