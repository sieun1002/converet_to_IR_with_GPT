; ModuleID: bfs_module
source_filename = "bfs_module"
target triple = "x86_64-pc-windows-msvc"

@.str_bfs = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str_zus = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str_dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare dso_local i32 @printf(i8*, ...) #0
declare dso_local i32 @putchar(i32) #0

define dso_local void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist_out, i64* %out_len, i64* %out_order) #0 {
entry:
  %queue = alloca i64, i64 %n, align 8
  %head = alloca i64, align 8
  %tail = alloca i64, align 8
  store i64 0, i64* %head, align 8
  store i64 0, i64* %tail, align 8
  store i64 0, i64* %out_len, align 8

  ; Initialize dist_out[i] = -1
  %i_init = alloca i64, align 8
  store i64 0, i64* %i_init, align 8
  br label %dist_loop_cond

dist_loop_cond:
  %i_val = load i64, i64* %i_init, align 8
  %cmp_i = icmp ult i64 %i_val, %n
  br i1 %cmp_i, label %dist_loop_body, label %dist_loop_end

dist_loop_body:
  %dist_ptr = getelementptr inbounds i32, i32* %dist_out, i64 %i_val
  store i32 -1, i32* %dist_ptr, align 4
  %i_next = add i64 %i_val, 1
  store i64 %i_next, i64* %i_init, align 8
  br label %dist_loop_cond

dist_loop_end:
  ; dist[start] = 0
  %dist_start_ptr = getelementptr inbounds i32, i32* %dist_out, i64 %start
  store i32 0, i32* %dist_start_ptr, align 4
  ; queue[0] = start; tail = 1
  %q0 = getelementptr inbounds i64, i64* %queue, i64 0
  store i64 %start, i64* %q0, align 8
  store i64 1, i64* %tail, align 8

  br label %while_cond

while_cond:
  %head_val = load i64, i64* %head, align 8
  %tail_val = load i64, i64* %tail, align 8
  %has_elem = icmp ult i64 %head_val, %tail_val
  br i1 %has_elem, label %while_body, label %while_end

while_body:
  ; u = queue[head]; head++
  %u_ptr = getelementptr inbounds i64, i64* %queue, i64 %head_val
  %u = load i64, i64* %u_ptr, align 8
  %head_inc = add i64 %head_val, 1
  store i64 %head_inc, i64* %head, align 8

  ; out_order[out_len] = u; out_len++
  %olen = load i64, i64* %out_len, align 8
  %order_slot = getelementptr inbounds i64, i64* %out_order, i64 %olen
  store i64 %u, i64* %order_slot, align 8
  %olen_inc = add i64 %olen, 1
  store i64 %olen_inc, i64* %out_len, align 8

  ; neighbor loop v = 0..n-1
  %v_it = alloca i64, align 8
  store i64 0, i64* %v_it, align 8
  br label %v_cond

v_cond:
  %v = load i64, i64* %v_it, align 8
  %v_cmp = icmp ult i64 %v, %n
  br i1 %v_cmp, label %v_body, label %v_end

v_body:
  ; idx = u*n + v
  %u_mul_n = mul i64 %u, %n
  %idx = add i64 %u_mul_n, %v
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %edge = load i32, i32* %adj_ptr, align 4
  %has_edge = icmp ne i32 %edge, 0
  br i1 %has_edge, label %check_unseen, label %v_next

check_unseen:
  %dist_v_ptr = getelementptr inbounds i32, i32* %dist_out, i64 %v
  %dist_v = load i32, i32* %dist_v_ptr, align 4
  %is_unseen = icmp eq i32 %dist_v, -1
  br i1 %is_unseen, label %enqueue, label %v_next

enqueue:
  ; dist[v] = dist[u] + 1
  %dist_u_ptr = getelementptr inbounds i32, i32* %dist_out, i64 %u
  %dist_u = load i32, i32* %dist_u_ptr, align 4
  %dist_u_inc = add i32 %dist_u, 1
  store i32 %dist_u_inc, i32* %dist_v_ptr, align 4
  ; queue[tail] = v; tail++
  %tail_now = load i64, i64* %tail, align 8
  %q_slot = getelementptr inbounds i64, i64* %queue, i64 %tail_now
  store i64 %v, i64* %q_slot, align 8
  %tail_next = add i64 %tail_now, 1
  store i64 %tail_next, i64* %tail, align 8
  br label %v_next

v_next:
  %v_inc = add i64 %v, 1
  store i64 %v_inc, i64* %v_it, align 8
  br label %v_cond

v_end:
  br label %while_cond

while_end:
  ret void
}

define dso_local i32 @main() #0 {
entry:
  ; N = 7
  %N = alloca i64, align 8
  store i64 7, i64* %N, align 8
  %n = load i64, i64* %N, align 8

  ; Allocate adjacency matrix of size n*n
  %nn = mul i64 %n, %n
  %adj = alloca i32, i64 %nn, align 4

  ; Zero adj
  %z_i = alloca i64, align 8
  store i64 0, i64* %z_i, align 8
  br label %z_cond

z_cond:
  %zv = load i64, i64* %z_i, align 8
  %z_cmp = icmp ult i64 %zv, %nn
  br i1 %z_cmp, label %z_body, label %z_end

z_body:
  %z_ptr = getelementptr inbounds i32, i32* %adj, i64 %zv
  store i32 0, i32* %z_ptr, align 4
  %zv_next = add i64 %zv, 1
  store i64 %zv_next, i64* %z_i, align 8
  br label %z_cond

z_end:
  ; Build simple chain graph: edges (i,i+1) and (i+1,i)
  %e_i = alloca i64, align 8
  store i64 0, i64* %e_i, align 8
  br label %e_cond

e_cond:
  %ei = load i64, i64* %e_i, align 8
  %n_minus_1 = add i64 %n, -1
  %e_cmp = icmp ult i64 %ei, %n_minus_1
  br i1 %e_cmp, label %e_body, label %e_end

e_body:
  ; idx1 = i*n + (i+1)
  %i_mul_n = mul i64 %ei, %n
  %i1 = add i64 %ei, 1
  %idx1 = add i64 %i_mul_n, %i1
  %ptr1 = getelementptr inbounds i32, i32* %adj, i64 %idx1
  store i32 1, i32* %ptr1, align 4

  ; idx2 = (i+1)*n + i
  %i1_mul_n = mul i64 %i1, %n
  %idx2 = add i64 %i1_mul_n, %ei
  %ptr2 = getelementptr inbounds i32, i32* %adj, i64 %idx2
  store i32 1, i32* %ptr2, align 4

  %ei_next = add i64 %ei, 1
  store i64 %ei_next, i64* %e_i, align 8
  br label %e_cond

e_end:
  ; Allocate dist, order, out_len
  %dist = alloca i32, i64 %n, align 4
  %order = alloca i64, i64 %n, align 8
  %out_len = alloca i64, align 8

  ; start = 0
  %start = alloca i64, align 8
  store i64 0, i64* %start, align 8
  store i64 0, i64* %out_len, align 8

  ; Call bfs(adj, n, start, dist, &out_len, order)
  %start_val = load i64, i64* %start, align 8
  call void @bfs(i32* %adj, i64 %n, i64 %start_val, i32* %dist, i64* %out_len, i64* %order)

  ; printf("BFS order from %zu: ", start)
  %fmt_bfs_ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str_bfs, i64 0, i64 0
  %start_for_print = load i64, i64* %start, align 8
  %call_printf_bfs = call i32 (i8*, ...) @printf(i8* %fmt_bfs_ptr, i64 %start_for_print)

  ; Loop to print order
  %pi = alloca i64, align 8
  store i64 0, i64* %pi, align 8
  br label %p_cond

p_cond:
  %pi_val = load i64, i64* %pi, align 8
  %olen_now = load i64, i64* %out_len, align 8
  %p_cmp = icmp ult i64 %pi_val, %olen_now
  br i1 %p_cmp, label %p_body, label %p_end

p_body:
  ; choose suffix: space if (pi+1 < out_len) else empty
  %pi_plus1 = add i64 %pi_val, 1
  %has_more = icmp ult i64 %pi_plus1, %olen_now
  br i1 %has_more, label %suffix_space, label %suffix_empty

suffix_space:
  %space_ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  br label %suffix_merge

suffix_empty:
  %empty_ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  br label %suffix_merge

suffix_merge:
  %suffix_phi = phi i8* [ %space_ptr, %suffix_space ], [ %empty_ptr, %suffix_empty ]
  ; load order[pi]
  %order_ptr = getelementptr inbounds i64, i64* %order, i64 %pi_val
  %ord_val = load i64, i64* %order_ptr, align 8
  %fmt_zus_ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str_zus, i64 0, i64 0
  %call_printf_item = call i32 (i8*, ...) @printf(i8* %fmt_zus_ptr, i64 %ord_val, i8* %suffix_phi)
  %pi_next = add i64 %pi_val, 1
  store i64 %pi_next, i64* %pi, align 8
  br label %p_cond

p_end:
  ; newline
  %nl = call i32 @putchar(i32 10)

  ; Print distances
  %dj = alloca i64, align 8
  store i64 0, i64* %dj, align 8
  br label %d_cond

d_cond:
  %j = load i64, i64* %dj, align 8
  %d_cmp = icmp ult i64 %j, %n
  br i1 %d_cmp, label %d_body, label %d_end

d_body:
  %dptr = getelementptr inbounds i32, i32* %dist, i64 %j
  %dval = load i32, i32* %dptr, align 4
  %fmt_dist_ptr = getelementptr inbounds [23 x i8], [23 x i8]* @.str_dist, i64 0, i64 0
  %start_print2 = load i64, i64* %start, align 8
  %call_printf_dist = call i32 (i8*, ...) @printf(i8* %fmt_dist_ptr, i64 %start_print2, i64 %j, i32 %dval)
  %j_next = add i64 %j, 1
  store i64 %j_next, i64* %dj, align 8
  br label %d_cond

d_end:
  ret i32 0
}

attributes #0 = { "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="0" "target-cpu"="x86-64" "target-features"="+64bit,+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }