; ModuleID = 'bfs_module'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare i8* @malloc(i64)
declare void @free(i8*)

define dso_local void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %order, i64* %outCount) {
entry:
  %cmp_n_zero = icmp eq i64 %n, 0
  br i1 %cmp_n_zero, label %invalid, label %check_start

check_start:
  %cmp_start = icmp ult i64 %start, %n
  br i1 %cmp_start, label %init_loop_header, label %invalid

init_loop_header:
  %i = phi i64 [ 0, %check_start ], [ %i.next, %init_loop_body ]
  %i_lt_n = icmp ult i64 %i, %n
  br i1 %i_lt_n, label %init_loop_body, label %post_init

init_loop_body:
  %dist_i_ptr = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist_i_ptr, align 4
  %i.next = add i64 %i, 1
  br label %init_loop_header

post_init:
  %alloc_size = shl i64 %n, 3
  %mem = call i8* @malloc(i64 %alloc_size)
  %block = bitcast i8* %mem to i64*
  %is_null = icmp eq i64* %block, null
  br i1 %is_null, label %invalid, label %init_queue

init_queue:
  %dist_start_ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist_start_ptr, align 4
  store i64 0, i64* %outCount, align 8
  %slot0 = getelementptr inbounds i64, i64* %block, i64 0
  store i64 %start, i64* %slot0, align 8
  br label %outer_header

outer_header:
  %head = phi i64 [ 0, %init_queue ], [ %head.next, %outer_after_inner ]
  %tail = phi i64 [ 1, %init_queue ], [ %tail.cur.exit, %outer_after_inner ]
  %has_items = icmp ult i64 %head, %tail
  br i1 %has_items, label %outer_body, label %finish

outer_body:
  %slot_ptr = getelementptr inbounds i64, i64* %block, i64 %head
  %u = load i64, i64* %slot_ptr, align 8
  %head.next = add i64 %head, 1
  %count.old = load i64, i64* %outCount, align 8
  %order_ptr = getelementptr inbounds i64, i64* %order, i64 %count.old
  store i64 %u, i64* %order_ptr, align 8
  %count.new = add i64 %count.old, 1
  store i64 %count.new, i64* %outCount, align 8
  br label %inner_header

inner_header:
  %j = phi i64 [ 0, %outer_body ], [ %j.next.noenq, %inner_inc_noenq ], [ %j.next.enq, %inner_inc_enq ]
  %tail.cur = phi i64 [ %tail, %outer_body ], [ %tail.cur.noenq, %inner_inc_noenq ], [ %tail.next, %inner_inc_enq ]
  %j_lt_n = icmp ult i64 %j, %n
  br i1 %j_lt_n, label %inner_body, label %outer_after_inner

inner_body:
  %mul = mul i64 %u, %n
  %idx = add i64 %mul, %j
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %edge = load i32, i32* %adj_ptr, align 4
  %edge_zero = icmp eq i32 %edge, 0
  br i1 %edge_zero, label %inner_inc_noenq, label %check_undiscovered

check_undiscovered:
  %dj_ptr = getelementptr inbounds i32, i32* %dist, i64 %j
  %dj = load i32, i32* %dj_ptr, align 4
  %is_neg1 = icmp eq i32 %dj, -1
  br i1 %is_neg1, label %discover, label %inner_inc_noenq

discover:
  %du_ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %du = load i32, i32* %du_ptr, align 4
  %du_inc = add nsw i32 %du, 1
  store i32 %du_inc, i32* %dj_ptr, align 4
  %slot_enq = getelementptr inbounds i64, i64* %block, i64 %tail.cur
  store i64 %j, i64* %slot_enq, align 8
  %tail.next = add i64 %tail.cur, 1
  br label %inner_inc_enq

inner_inc_noenq:
  %j.next.noenq = add i64 %j, 1
  %tail.cur.noenq = add i64 %tail.cur, 0
  br label %inner_header

inner_inc_enq:
  %j.next.enq = add i64 %j, 1
  br label %inner_header

outer_after_inner:
  %tail.cur.exit = add i64 %tail.cur, 0
  br label %outer_header

finish:
  %mem_free = bitcast i64* %block to i8*
  call void @free(i8* %mem_free)
  ret void

invalid:
  store i64 0, i64* %outCount, align 8
  ret void
}