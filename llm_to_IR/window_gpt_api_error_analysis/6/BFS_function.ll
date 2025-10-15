; ModuleID = 'bfs_module'
target triple = "x86_64-pc-windows-msvc"

declare i8* @malloc(i64)
declare void @free(i8*)

define void @bfs(i32* %matrix, i64 %n, i64 %start, i32* %dist, i64* %out_arr, i64* %out_countptr) {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  br i1 %n_is_zero, label %early_zero, label %check_start

early_zero:
  store i64 0, i64* %out_countptr, align 8
  br label %ret

check_start:
  %start_in_range = icmp ult i64 %start, %n
  br i1 %start_in_range, label %init_dist_loop, label %early_zero2

early_zero2:
  store i64 0, i64* %out_countptr, align 8
  br label %ret

init_dist_loop:
  br label %dist_loop

dist_loop:
  %i = phi i64 [ 0, %init_dist_loop ], [ %i.next, %dist_loop_body ]
  %i_cond = icmp ult i64 %i, %n
  br i1 %i_cond, label %dist_loop_body, label %after_init

dist_loop_body:
  %dist_ptr.i = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist_ptr.i, align 4
  %i.next = add i64 %i, 1
  br label %dist_loop

after_init:
  %n_bytes = shl i64 %n, 3
  %block_i8 = call i8* @malloc(i64 %n_bytes)
  %block_null = icmp eq i8* %block_i8, null
  br i1 %block_null, label %early_zero3, label %init_queue

early_zero3:
  store i64 0, i64* %out_countptr, align 8
  br label %ret

init_queue:
  %block = bitcast i8* %block_i8 to i64*
  %dist_start_ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist_start_ptr, align 4
  %qpos0 = getelementptr inbounds i64, i64* %block, i64 0
  store i64 %start, i64* %qpos0, align 8
  store i64 0, i64* %out_countptr, align 8
  br label %main_while

main_while:
  %head = phi i64 [ 0, %init_queue ], [ %head.next, %after_neighbors ]
  %tail = phi i64 [ 1, %init_queue ], [ %tail.exit, %after_neighbors ]
  %has_items = icmp ult i64 %head, %tail
  br i1 %has_items, label %dequeue, label %done_main

dequeue:
  %curr_ptr = getelementptr inbounds i64, i64* %block, i64 %head
  %curr = load i64, i64* %curr_ptr, align 8
  %head.next = add i64 %head, 1
  %old_count = load i64, i64* %out_countptr, align 8
  %new_count = add i64 %old_count, 1
  store i64 %new_count, i64* %out_countptr, align 8
  %out_slot = getelementptr inbounds i64, i64* %out_arr, i64 %old_count
  store i64 %curr, i64* %out_slot, align 8
  br label %neighbor_loop

neighbor_loop:
  %j = phi i64 [ 0, %dequeue ], [ %j.next, %after_check ]
  %tail.loop = phi i64 [ %tail, %dequeue ], [ %tail.new, %after_check ]
  %j_cond = icmp ult i64 %j, %n
  br i1 %j_cond, label %check_edge, label %after_neighbors

check_edge:
  %mul = mul i64 %curr, %n
  %idx = add i64 %mul, %j
  %mat_ptr = getelementptr inbounds i32, i32* %matrix, i64 %idx
  %edge_val = load i32, i32* %mat_ptr, align 4
  %edge_nz = icmp ne i32 %edge_val, 0
  br i1 %edge_nz, label %check_unvisited, label %edge_false

check_unvisited:
  %dist_j_ptr = getelementptr inbounds i32, i32* %dist, i64 %j
  %dj = load i32, i32* %dist_j_ptr, align 4
  %is_neg1 = icmp eq i32 %dj, -1
  br i1 %is_neg1, label %visit_neighbor, label %nonvisit

visit_neighbor:
  %dist_curr_ptr = getelementptr inbounds i32, i32* %dist, i64 %curr
  %dcur = load i32, i32* %dist_curr_ptr, align 4
  %dcur.plus = add i32 %dcur, 1
  store i32 %dcur.plus, i32* %dist_j_ptr, align 4
  %tail_pos_ptr = getelementptr inbounds i64, i64* %block, i64 %tail.loop
  store i64 %j, i64* %tail_pos_ptr, align 8
  %tail.inc = add i64 %tail.loop, 1
  br label %after_check_with_tail

after_check_with_tail:
  br label %after_check

edge_false:
  br label %after_check

nonvisit:
  br label %after_check

after_check:
  %tail.new = phi i64 [ %tail.loop, %edge_false ], [ %tail.loop, %nonvisit ], [ %tail.inc, %after_check_with_tail ]
  %j.next = add i64 %j, 1
  br label %neighbor_loop

after_neighbors:
  %tail.exit = phi i64 [ %tail.loop, %neighbor_loop ]
  br label %main_while

done_main:
  call void @free(i8* %block_i8)
  br label %ret

ret:
  ret void
}