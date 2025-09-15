; ModuleID = 'BFS.bc'
source_filename = "llvm-link"
target triple = "x86_64-unknown-linux-gnu"

@.str.header = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str.sep = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

define i32 @main() {
entry:
  %adj = alloca [49 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %n = alloca i64, align 8
  %src = alloca i64, align 8
  %order_len = alloca i64, align 8
  store i64 7, i64* %n, align 8
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 196, i1 false)
  %gep1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %gep1, align 4
  %gep2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %gep2, align 4
  %n1 = load i64, i64* %n, align 8
  %gep_n = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %n1
  store i32 1, i32* %gep_n, align 4
  %n2 = load i64, i64* %n, align 8
  %mul2n = shl i64 %n2, 1
  %gep_2n = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %mul2n
  store i32 1, i32* %gep_2n, align 4
  %n3 = load i64, i64* %n, align 8
  %n3_add = add i64 %n3, 3
  %gep_n3 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %n3_add
  store i32 1, i32* %gep_n3, align 4
  %n4 = load i64, i64* %n, align 8
  %twon4 = shl i64 %n4, 1
  %threen4 = add i64 %twon4, %n4
  %threen4p1 = add i64 %threen4, 1
  %gep_3n1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %threen4p1
  store i32 1, i32* %gep_3n1, align 4
  %n5 = load i64, i64* %n, align 8
  %n5_add = add i64 %n5, 4
  %gep_n4 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %n5_add
  store i32 1, i32* %gep_n4, align 4
  %n6 = load i64, i64* %n, align 8
  %fourn6 = shl i64 %n6, 2
  %fourn6p1 = add i64 %fourn6, 1
  %gep_4n1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %fourn6p1
  store i32 1, i32* %gep_4n1, align 4
  %n7 = load i64, i64* %n, align 8
  %twon7 = shl i64 %n7, 1
  %twon7p5 = add i64 %twon7, 5
  %gep_2n5 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %twon7p5
  store i32 1, i32* %gep_2n5, align 4
  %n8 = load i64, i64* %n, align 8
  %fourn8 = shl i64 %n8, 2
  %fiven8 = add i64 %fourn8, %n8
  %fiven8p2 = add i64 %fiven8, 2
  %gep_5n2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %fiven8p2
  store i32 1, i32* %gep_5n2, align 4
  %n9 = load i64, i64* %n, align 8
  %fourn9b = shl i64 %n9, 2
  %fourn9b5 = add i64 %fourn9b, 5
  %gep_4n5 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %fourn9b5
  store i32 1, i32* %gep_4n5, align 4
  %n10 = load i64, i64* %n, align 8
  %fourn10 = shl i64 %n10, 2
  %fiven10 = add i64 %fourn10, %n10
  %fiven10p4 = add i64 %fiven10, 4
  %gep_5n4 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %fiven10p4
  store i32 1, i32* %gep_5n4, align 4
  %n11 = load i64, i64* %n, align 8
  %fourn11 = shl i64 %n11, 2
  %fiven11 = add i64 %fourn11, %n11
  %fiven11p6 = add i64 %fiven11, 6
  %gep_5n6 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %fiven11p6
  store i32 1, i32* %gep_5n6, align 4
  %n12 = load i64, i64* %n, align 8
  %twon12 = shl i64 %n12, 1
  %threen12 = add i64 %twon12, %n12
  %sixn12 = shl i64 %threen12, 1
  %sixn12p5 = add i64 %sixn12, 5
  %gep_6n5 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %sixn12p5
  store i32 1, i32* %gep_6n5, align 4
  store i64 0, i64* %src, align 8
  store i64 0, i64* %order_len, align 8
  %adjptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %distptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %orderptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  %nval = load i64, i64* %n, align 8
  %srcval = load i64, i64* %src, align 8
  call void @bfs(i32* %adjptr, i64 %nval, i64 %srcval, i32* %distptr, i64* %orderptr, i64* %order_len)
  %fmt_header_ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str.header, i64 0, i64 0
  %srcval2 = load i64, i64* %src, align 8
  %call_printf_hdr = call i32 (i8*, ...) @printf(i8* %fmt_header_ptr, i64 %srcval2)
  br label %print_loop.header

print_loop.header:                                ; preds = %print_loop.latch, %entry
  %i_phi = phi i64 [ 0, %entry ], [ %i_next, %print_loop.latch ]
  %len_cur = load i64, i64* %order_len, align 8
  %cmp_i_len = icmp ult i64 %i_phi, %len_cur
  br i1 %cmp_i_len, label %print_loop.body, label %print_loop.exit

print_loop.body:                                  ; preds = %print_loop.header
  %i_plus1 = add i64 %i_phi, 1
  %len_cur2 = load i64, i64* %order_len, align 8
  %has_space = icmp ult i64 %i_plus1, %len_cur2
  %space_ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  %empty_ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  %sep_ptr = select i1 %has_space, i8* %space_ptr, i8* %empty_ptr
  %order_elem_ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %i_phi
  %order_elem = load i64, i64* %order_elem_ptr, align 8
  %fmt_sep_ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str.sep, i64 0, i64 0
  %call_printf_item = call i32 (i8*, ...) @printf(i8* %fmt_sep_ptr, i64 %order_elem, i8* %sep_ptr)
  br label %print_loop.latch

print_loop.latch:                                 ; preds = %print_loop.body
  %i_next = add i64 %i_phi, 1
  br label %print_loop.header

print_loop.exit:                                  ; preds = %print_loop.header
  %nl_call = call i32 @putchar(i32 10)
  br label %dist_loop.header

dist_loop.header:                                 ; preds = %dist_loop.latch, %print_loop.exit
  %j_phi = phi i64 [ 0, %print_loop.exit ], [ %j_next, %dist_loop.latch ]
  %n_cur = load i64, i64* %n, align 8
  %cmp_j_n = icmp ult i64 %j_phi, %n_cur
  br i1 %cmp_j_n, label %dist_loop.body, label %dist_loop.exit

dist_loop.body:                                   ; preds = %dist_loop.header
  %dist_elem_ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %j_phi
  %dist_elem = load i32, i32* %dist_elem_ptr, align 4
  %fmt_dist_ptr = getelementptr inbounds [23 x i8], [23 x i8]* @.str.dist, i64 0, i64 0
  %srcval3 = load i64, i64* %src, align 8
  %j_val = add i64 %j_phi, 0
  %call_printf_dist = call i32 (i8*, ...) @printf(i8* %fmt_dist_ptr, i64 %srcval3, i64 %j_val, i32 %dist_elem)
  br label %dist_loop.latch

dist_loop.latch:                                  ; preds = %dist_loop.body
  %j_next = add i64 %j_phi, 1
  br label %dist_loop.header

dist_loop.exit:                                   ; preds = %dist_loop.header
  ret i32 0
}

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #0

declare i32 @printf(i8*, ...)

declare i32 @putchar(i32)

define void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %out, i64* %outCount) {
entry:
  %cmp_n0 = icmp eq i64 %n, 0
  br i1 %cmp_n0, label %early_ret, label %check_start

check_start:                                      ; preds = %entry
  %cmp_start = icmp ult i64 %start, %n
  br i1 %cmp_start, label %init_loop.entry, label %early_ret

early_ret:                                        ; preds = %check_start, %entry
  store i64 0, i64* %outCount, align 8
  ret void

init_loop.entry:                                  ; preds = %check_start
  br label %init_loop.cond

init_loop.cond:                                   ; preds = %init_loop.body, %init_loop.entry
  %i = phi i64 [ 0, %init_loop.entry ], [ %i.next, %init_loop.body ]
  %cond_i = icmp ult i64 %i, %n
  br i1 %cond_i, label %init_loop.body, label %alloc_queue

init_loop.body:                                   ; preds = %init_loop.cond
  %gep_dist_i = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %gep_dist_i, align 4
  %i.next = add i64 %i, 1
  br label %init_loop.cond

alloc_queue:                                      ; preds = %init_loop.cond
  %size_elems = shl i64 %n, 3
  %qraw = call noalias i8* @malloc(i64 %size_elems)
  %queue = bitcast i8* %qraw to i64*
  %isnull = icmp eq i64* %queue, null
  br i1 %isnull, label %malloc_fail, label %bfs_init

malloc_fail:                                      ; preds = %alloc_queue
  store i64 0, i64* %outCount, align 8
  ret void

bfs_init:                                         ; preds = %alloc_queue
  %dist_start_ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist_start_ptr, align 4
  %qpos0 = getelementptr inbounds i64, i64* %queue, i64 0
  store i64 %start, i64* %qpos0, align 8
  store i64 0, i64* %outCount, align 8
  br label %outer_cond

outer_cond:                                       ; preds = %after_inner, %bfs_init
  %head.phi = phi i64 [ 0, %bfs_init ], [ %head.next, %after_inner ]
  %tail.phi = phi i64 [ 1, %bfs_init ], [ %tail.inner, %after_inner ]
  %cmp_ht = icmp ult i64 %head.phi, %tail.phi
  br i1 %cmp_ht, label %outer_body, label %exit

outer_body:                                       ; preds = %outer_cond
  %qhead.ptr = getelementptr inbounds i64, i64* %queue, i64 %head.phi
  %x = load i64, i64* %qhead.ptr, align 8
  %head.next = add i64 %head.phi, 1
  %count0 = load i64, i64* %outCount, align 8
  %count1 = add i64 %count0, 1
  store i64 %count1, i64* %outCount, align 8
  %out.ptr = getelementptr inbounds i64, i64* %out, i64 %count0
  store i64 %x, i64* %out.ptr, align 8
  br label %inner_cond

inner_cond:                                       ; preds = %inner_latch, %outer_body
  %i2 = phi i64 [ 0, %outer_body ], [ %i2.next, %inner_latch ]
  %tail.inner = phi i64 [ %tail.phi, %outer_body ], [ %tail.next, %inner_latch ]
  %cond_i2 = icmp ult i64 %i2, %n
  br i1 %cond_i2, label %inner_body, label %after_inner

inner_body:                                       ; preds = %inner_cond
  %xn = mul i64 %x, %n
  %idx = add i64 %xn, %i2
  %adj.ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %adj.val = load i32, i32* %adj.ptr, align 4
  %adj.iszero = icmp eq i32 %adj.val, 0
  br i1 %adj.iszero, label %inner_skip, label %check_unvisited

check_unvisited:                                  ; preds = %inner_body
  %dist_i_ptr = getelementptr inbounds i32, i32* %dist, i64 %i2
  %dist_i_val = load i32, i32* %dist_i_ptr, align 4
  %is_unvisited = icmp eq i32 %dist_i_val, -1
  br i1 %is_unvisited, label %visit, label %inner_skip

visit:                                            ; preds = %check_unvisited
  %dist_x_ptr = getelementptr inbounds i32, i32* %dist, i64 %x
  %dist_x_val = load i32, i32* %dist_x_ptr, align 4
  %dist_x_plus1 = add i32 %dist_x_val, 1
  store i32 %dist_x_plus1, i32* %dist_i_ptr, align 4
  %qtail.ptr = getelementptr inbounds i64, i64* %queue, i64 %tail.inner
  store i64 %i2, i64* %qtail.ptr, align 8
  %tail.next.visit = add i64 %tail.inner, 1
  br label %inner_latch

inner_skip:                                       ; preds = %check_unvisited, %inner_body
  br label %inner_latch

inner_latch:                                      ; preds = %inner_skip, %visit
  %tail.next = phi i64 [ %tail.next.visit, %visit ], [ %tail.inner, %inner_skip ]
  %i2.next = add i64 %i2, 1
  br label %inner_cond

after_inner:                                      ; preds = %inner_cond
  br label %outer_cond

exit:                                             ; preds = %outer_cond
  %queue.cast = bitcast i64* %queue to i8*
  call void @free(i8* %queue.cast)
  ret void
}

declare noalias i8* @malloc(i64)

declare void @free(i8*)

attributes #0 = { argmemonly nofree nounwind willreturn writeonly }
