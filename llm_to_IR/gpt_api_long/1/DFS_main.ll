; ModuleID = 'dfs'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: dfs  ; Address: 0x11C9
; Intent: Iterative DFS from a start node on an adjacency matrix, outputting visit order and count (confidence=0.95). Evidence: current*n+neighbor indexing into i32 matrix; separate visited[] and stack arrays.
; Preconditions: adj is an n-by-n row-major i32 matrix; out has capacity >= n.
; Postconditions: out[0..*out_len-1] is the DFS visitation order starting at start; *out_len is the number of visited nodes.

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define dso_local void @dfs(i32* %adj, i64 %n, i64 %start, i64* %out, i64* %out_len) local_unnamed_addr {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  br i1 %n_is_zero, label %early_zero, label %check_start

early_zero:
  store i64 0, i64* %out_len, align 8
  ret void

check_start:
  %start_ok = icmp ult i64 %start, %n
  br i1 %start_ok, label %allocs, label %early_bad_start

early_bad_start:
  store i64 0, i64* %out_len, align 8
  ret void

allocs:
  %size_i32 = shl i64 %n, 2
  %p1 = call noalias i8* @malloc(i64 %size_i32)
  %visited = bitcast i8* %p1 to i32*
  %size_i64 = shl i64 %n, 3
  %p2 = call noalias i8* @malloc(i64 %size_i64)
  %nextidx_i8 = %p2
  %nextidx = bitcast i8* %nextidx_i8 to i64*
  %p3 = call noalias i8* @malloc(i64 %size_i64)
  %stack_i8 = %p3
  %stack = bitcast i8* %stack_i8 to i64*
  %vis_null = icmp eq i8* %p1, null
  %next_null = icmp eq i8* %nextidx_i8, null
  %stack_null = icmp eq i8* %stack_i8, null
  %any_null1 = or i1 %vis_null, %next_null
  %any_null = or i1 %any_null1, %stack_null
  br i1 %any_null, label %alloc_fail, label %init_loop

alloc_fail:
  call void @free(i8* %p1)
  call void @free(i8* %nextidx_i8)
  call void @free(i8* %stack_i8)
  store i64 0, i64* %out_len, align 8
  ret void

init_loop:
  br label %init_loop.header

init_loop.header:
  %i = phi i64 [ 0, %init_loop ], [ %i.next, %init_loop.body ]
  %cond = icmp ult i64 %i, %n
  br i1 %cond, label %init_loop.body, label %init_done

init_loop.body:
  %vptr = getelementptr inbounds i32, i32* %visited, i64 %i
  store i32 0, i32* %vptr, align 4
  %nptr = getelementptr inbounds i64, i64* %nextidx, i64 %i
  store i64 0, i64* %nptr, align 8
  %i.next = add i64 %i, 1
  br label %init_loop.header

init_done:
  store i64 0, i64* %out_len, align 8
  %stack_slot0 = getelementptr inbounds i64, i64* %stack, i64 0
  store i64 %start, i64* %stack_slot0, align 8
  %v_start_ptr = getelementptr inbounds i32, i32* %visited, i64 %start
  store i32 1, i32* %v_start_ptr, align 4
  %count0 = load i64, i64* %out_len, align 8
  %count1 = add i64 %count0, 1
  store i64 %count1, i64* %out_len, align 8
  %out_ptr0 = getelementptr inbounds i64, i64* %out, i64 %count0
  store i64 %start, i64* %out_ptr0, align 8
  br label %main_loop.header

main_loop.header:
  %stack_size = phi i64 [ 1, %init_done ], [ %stack_size.next, %after_inner ], [ %stack_size.after_pop, %pop_block ]
  %has_items = icmp ne i64 %stack_size, 0
  br i1 %has_items, label %top_setup, label %finish

top_setup:
  %top_index = add i64 %stack_size, -1
  %top_ptr = getelementptr inbounds i64, i64* %stack, i64 %top_index
  %top = load i64, i64* %top_ptr, align 8
  %nextptr_top = getelementptr inbounds i64, i64* %nextidx, i64 %top
  %neighbor0 = load i64, i64* %nextptr_top, align 8
  br label %inner_loop.header

inner_loop.header:
  %neighbor = phi i64 [ %neighbor0, %top_setup ], [ %neighbor.inc, %inner_no_take ]
  %neighbor_ok = icmp ult i64 %neighbor, %n
  br i1 %neighbor_ok, label %check_edge, label %pop_block

check_edge:
  %top_mul_n = mul i64 %top, %n
  %idx_flat = add i64 %top_mul_n, %neighbor
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %idx_flat
  %adj_val = load i32, i32* %adj_ptr, align 4
  %has_edge = icmp ne i32 %adj_val, 0
  br i1 %has_edge, label %check_unvisited, label %inner_no_take

check_unvisited:
  %v_nei_ptr = getelementptr inbounds i32, i32* %visited, i64 %neighbor
  %v_nei = load i32, i32* %v_nei_ptr, align 4
  %is_unvisited = icmp eq i32 %v_nei, 0
  br i1 %is_unvisited, label %take_edge, label %inner_no_take

take_edge:
  %neighbor.plus1 = add i64 %neighbor, 1
  store i64 %neighbor.plus1, i64* %nextptr_top, align 8
  store i32 1, i32* %v_nei_ptr, align 4
  %countA = load i64, i64* %out_len, align 8
  %countA1 = add i64 %countA, 1
  store i64 %countA1, i64* %out_len, align 8
  %out_ptrA = getelementptr inbounds i64, i64* %out, i64 %countA
  store i64 %neighbor, i64* %out_ptrA, align 8
  %stack_push_ptr = getelementptr inbounds i64, i64* %stack, i64 %stack_size
  store i64 %neighbor, i64* %stack_push_ptr, align 8
  %stack_size.next = add i64 %stack_size, 1
  br label %after_inner

inner_no_take:
  %neighbor.inc = add i64 %neighbor, 1
  br label %inner_loop.header

pop_block:
  %stack_size.after_pop = add i64 %stack_size, -1
  br label %main_loop.header

after_inner:
  br label %main_loop.header

finish:
  call void @free(i8* %p1)
  call void @free(i8* %nextidx_i8)
  call void @free(i8* %stack_i8)
  ret void
}