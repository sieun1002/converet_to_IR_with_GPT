; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/integration/bc/4/BFS.ll'
source_filename = "llvm-link"
target triple = "x86_64-pc-linux-gnu"

@.str_bfs = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str_zu_s = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str_dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

define dso_local i32 @main() {
entry:
  %adj = alloca [49 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %order_len = alloca i64, align 8
  %adj_i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(196) %adj_i8, i8 0, i64 196, i1 false)
  store i64 0, i64* %order_len, align 8
  %adj_base_ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %adj_base_ptr, align 4
  %adj_0_2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %adj_0_2, align 8
  %adj_1_0 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 7
  store i32 1, i32* %adj_1_0, align 4
  %adj_1_3 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 10
  store i32 1, i32* %adj_1_3, align 8
  %adj_1_4 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 11
  store i32 1, i32* %adj_1_4, align 4
  %adj_2_0 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 14
  store i32 1, i32* %adj_2_0, align 8
  %adj_2_5 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 19
  store i32 1, i32* %adj_2_5, align 4
  %adj_3_1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 22
  store i32 1, i32* %adj_3_1, align 8
  %adj_4_1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 29
  store i32 1, i32* %adj_4_1, align 4
  %adj_4_5 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 33
  store i32 1, i32* %adj_4_5, align 4
  %adj_5_2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 37
  store i32 1, i32* %adj_5_2, align 4
  %adj_5_4 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 39
  store i32 1, i32* %adj_5_4, align 4
  %adj_5_6 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 41
  store i32 1, i32* %adj_5_6, align 4
  %adj_6_5 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 47
  store i32 1, i32* %adj_6_5, align 4
  %adj_ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %dist_ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %order_ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  call void @bfs(i32* nonnull %adj_ptr, i64 7, i64 0, i32* nonnull %dist_ptr, i64* nonnull %order_ptr, i64* nonnull %order_len)
  %call_printf_hdr = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([21 x i8], [21 x i8]* @.str_bfs, i64 0, i64 0), i64 0)
  br label %order_loop_cond

order_loop_cond:                                  ; preds = %order_loop_body, %entry
  %i.0 = phi i64 [ 0, %entry ], [ %i_plus1, %order_loop_body ]
  %len_cur = load i64, i64* %order_len, align 8
  %cmp_i_len = icmp ult i64 %i.0, %len_cur
  br i1 %cmp_i_len, label %order_loop_body, label %order_loop_end

order_loop_body:                                  ; preds = %order_loop_cond
  %i_plus1 = add i64 %i.0, 1
  %cmp_next = icmp ult i64 %i_plus1, %len_cur
  %. = select i1 %cmp_next, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str_space, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0)
  %elem_ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %i.0
  %elem_val = load i64, i64* %elem_ptr, align 8
  %call_printf_item = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([6 x i8], [6 x i8]* @.str_zu_s, i64 0, i64 0), i64 %elem_val, i8* %.)
  br label %order_loop_cond

order_loop_end:                                   ; preds = %order_loop_cond
  %newline = call i32 @putchar(i32 10)
  br label %dist_loop_cond

dist_loop_cond:                                   ; preds = %dist_loop_body, %order_loop_end
  %v.0 = phi i64 [ 0, %order_loop_end ], [ %v_next, %dist_loop_body ]
  %cmp_v_n = icmp ult i64 %v.0, 7
  br i1 %cmp_v_n, label %dist_loop_body, label %dist_loop_end

dist_loop_body:                                   ; preds = %dist_loop_cond
  %dist_ptr_v = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %v.0
  %dist_val = load i32, i32* %dist_ptr_v, align 4
  %call_printf_dist = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([23 x i8], [23 x i8]* @.str_dist, i64 0, i64 0), i64 0, i64 %v.0, i32 %dist_val)
  %v_next = add i64 %v.0, 1
  br label %dist_loop_cond

dist_loop_end:                                    ; preds = %dist_loop_cond
  ret i32 0
}

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #0

declare i32 @printf(i8*, ...)

declare i32 @putchar(i32)

define void @bfs(i32* %adj, i64 %n, i64 %src, i32* %dist, i64* %out, i64* %out_len) {
entry:
  %n_is_zero = icmp ne i64 %n, 0
  %src_in_range = icmp ult i64 %src, %n
  %or.cond = select i1 %n_is_zero, i1 %src_in_range, i1 false
  br i1 %or.cond, label %init_loop.header, label %ret_zero

common.ret:                                       ; preds = %exit, %ret_zero
  ret void

ret_zero:                                         ; preds = %post_init, %entry
  store i64 0, i64* %out_len, align 4
  br label %common.ret

init_loop.header:                                 ; preds = %entry, %init_loop.body
  %i = phi i64 [ %i.next, %init_loop.body ], [ 0, %entry ]
  %i_lt_n = icmp ult i64 %i, %n
  br i1 %i_lt_n, label %init_loop.body, label %post_init

init_loop.body:                                   ; preds = %init_loop.header
  %dist_i_ptr = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist_i_ptr, align 4
  %i.next = add i64 %i, 1
  br label %init_loop.header

post_init:                                        ; preds = %init_loop.header
  %size_bytes = shl i64 %n, 3
  %mem = call noalias i8* @malloc(i64 %size_bytes)
  %mem_null = icmp eq i8* %mem, null
  br i1 %mem_null, label %ret_zero, label %init_queue

init_queue:                                       ; preds = %post_init
  %q = bitcast i8* %mem to i64*
  %dist_src_ptr = getelementptr inbounds i32, i32* %dist, i64 %src
  store i32 0, i32* %dist_src_ptr, align 4
  store i64 %src, i64* %q, align 4
  store i64 0, i64* %out_len, align 4
  br label %outer.header

outer.header:                                     ; preds = %inner.header, %init_queue
  %head = phi i64 [ 0, %init_queue ], [ %head.next, %inner.header ]
  %tail = phi i64 [ 1, %init_queue ], [ %tail.cur, %inner.header ]
  %has_items = icmp ult i64 %head, %tail
  br i1 %has_items, label %outer.body, label %exit

outer.body:                                       ; preds = %outer.header
  %q_u_ptr = getelementptr inbounds i64, i64* %q, i64 %head
  %u = load i64, i64* %q_u_ptr, align 4
  %head.next = add i64 %head, 1
  %len_old = load i64, i64* %out_len, align 4
  %len_new = add i64 %len_old, 1
  store i64 %len_new, i64* %out_len, align 4
  %out_slot = getelementptr inbounds i64, i64* %out, i64 %len_old
  store i64 %u, i64* %out_slot, align 4
  br label %inner.header

inner.header:                                     ; preds = %inner.latch, %outer.body
  %v = phi i64 [ 0, %outer.body ], [ %v.next, %inner.latch ]
  %tail.cur = phi i64 [ %tail, %outer.body ], [ %tail.next, %inner.latch ]
  %v_lt_n = icmp ult i64 %v, %n
  br i1 %v_lt_n, label %inner.check_adj, label %outer.header

inner.check_adj:                                  ; preds = %inner.header
  %mul_un = mul i64 %u, %n
  %idx_mat = add i64 %mul_un, %v
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %idx_mat
  %adj_val = load i32, i32* %adj_ptr, align 4
  %adj_is_zero = icmp eq i32 %adj_val, 0
  br i1 %adj_is_zero, label %inner.latch, label %inner.check_visit

inner.check_visit:                                ; preds = %inner.check_adj
  %dist_v_ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %dist_v = load i32, i32* %dist_v_ptr, align 4
  %is_unvisited = icmp eq i32 %dist_v, -1
  br i1 %is_unvisited, label %visit, label %inner.latch

visit:                                            ; preds = %inner.check_visit
  %dist_u_ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %dist_u = load i32, i32* %dist_u_ptr, align 4
  %dist_u_plus1 = add i32 %dist_u, 1
  store i32 %dist_u_plus1, i32* %dist_v_ptr, align 4
  %q_tail_ptr = getelementptr inbounds i64, i64* %q, i64 %tail.cur
  store i64 %v, i64* %q_tail_ptr, align 4
  %tail.enq = add i64 %tail.cur, 1
  br label %inner.latch

inner.latch:                                      ; preds = %inner.check_adj, %inner.check_visit, %visit
  %tail.next = phi i64 [ %tail.enq, %visit ], [ %tail.cur, %inner.check_visit ], [ %tail.cur, %inner.check_adj ]
  %v.next = add i64 %v, 1
  br label %inner.header

exit:                                             ; preds = %outer.header
  call void @free(i8* %mem)
  br label %common.ret
}

declare noalias i8* @malloc(i64)

declare void @free(i8*)

attributes #0 = { argmemonly nofree nounwind willreturn writeonly }
