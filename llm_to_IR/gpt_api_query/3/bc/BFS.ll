; ModuleID = 'BFS.bc'
source_filename = "llvm-link"
target triple = "x86_64-pc-linux-gnu"

@.str.bfs = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.zus = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

define i32 @main() {
entry:
  %adj = alloca [49 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %orderLen = alloca i64, align 8
  %src = alloca i64, align 8
  %i = alloca i64, align 8
  %k = alloca i64, align 8
  store i64 0, i64* %src, align 8
  store i64 0, i64* %orderLen, align 8
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 196, i1 false)
  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %p7 = getelementptr inbounds i32, i32* %adj.base, i64 7
  store i32 1, i32* %p7, align 4
  %p14 = getelementptr inbounds i32, i32* %adj.base, i64 14
  store i32 1, i32* %p14, align 4
  %p10 = getelementptr inbounds i32, i32* %adj.base, i64 10
  store i32 1, i32* %p10, align 4
  %p22 = getelementptr inbounds i32, i32* %adj.base, i64 22
  store i32 1, i32* %p22, align 4
  %p11 = getelementptr inbounds i32, i32* %adj.base, i64 11
  store i32 1, i32* %p11, align 4
  %p29 = getelementptr inbounds i32, i32* %adj.base, i64 29
  store i32 1, i32* %p29, align 4
  %p19 = getelementptr inbounds i32, i32* %adj.base, i64 19
  store i32 1, i32* %p19, align 4
  %p37 = getelementptr inbounds i32, i32* %adj.base, i64 37
  store i32 1, i32* %p37, align 4
  %p33 = getelementptr inbounds i32, i32* %adj.base, i64 33
  store i32 1, i32* %p33, align 4
  %p39 = getelementptr inbounds i32, i32* %adj.base, i64 39
  store i32 1, i32* %p39, align 4
  %p41 = getelementptr inbounds i32, i32* %adj.base, i64 41
  store i32 1, i32* %p41, align 4
  %p47 = getelementptr inbounds i32, i32* %adj.base, i64 47
  store i32 1, i32* %p47, align 4
  %adj.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %dist.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %order.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  %src.val = load i64, i64* %src, align 8
  call void @bfs(i32* %adj.ptr, i64 7, i64 %src.val, i32* %dist.ptr, i64* %order.ptr, i64* %orderLen)
  %fmt.bfs = getelementptr inbounds [21 x i8], [21 x i8]* @.str.bfs, i64 0, i64 0
  %src.val2 = load i64, i64* %src, align 8
  %call0 = call i32 (i8*, ...) @printf(i8* %fmt.bfs, i64 %src.val2)
  store i64 0, i64* %i, align 8
  br label %loop_order.cond

loop_order.cond:                                  ; preds = %loop_order.body, %entry
  %i.cur = load i64, i64* %i, align 8
  %len = load i64, i64* %orderLen, align 8
  %cmp = icmp ult i64 %i.cur, %len
  br i1 %cmp, label %loop_order.body, label %loop_order.end

loop_order.body:                                  ; preds = %loop_order.cond
  %next = add i64 %i.cur, 1
  %is_last = icmp uge i64 %next, %len
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  %delim = select i1 %is_last, i8* %empty.ptr, i8* %space.ptr
  %ord.base = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  %ord.ptr = getelementptr inbounds i64, i64* %ord.base, i64 %i.cur
  %ord.val = load i64, i64* %ord.ptr, align 8
  %fmt.zus = getelementptr inbounds [6 x i8], [6 x i8]* @.str.zus, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt.zus, i64 %ord.val, i8* %delim)
  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop_order.cond

loop_order.end:                                   ; preds = %loop_order.cond
  %call2 = call i32 @putchar(i32 10)
  store i64 0, i64* %k, align 8
  br label %loop_dist.cond

loop_dist.cond:                                   ; preds = %loop_dist.body, %loop_order.end
  %k.cur = load i64, i64* %k, align 8
  %cmpk = icmp ult i64 %k.cur, 7
  br i1 %cmpk, label %loop_dist.body, label %loop_dist.end

loop_dist.body:                                   ; preds = %loop_dist.cond
  %d.ptr = getelementptr inbounds i32, i32* %dist.ptr, i64 %k.cur
  %d.val = load i32, i32* %d.ptr, align 4
  %fmt.dist = getelementptr inbounds [23 x i8], [23 x i8]* @.str.dist, i64 0, i64 0
  %src.val3 = load i64, i64* %src, align 8
  %call3 = call i32 (i8*, ...) @printf(i8* %fmt.dist, i64 %src.val3, i64 %k.cur, i32 %d.val)
  %k.next = add i64 %k.cur, 1
  store i64 %k.next, i64* %k, align 8
  br label %loop_dist.cond

loop_dist.end:                                    ; preds = %loop_dist.cond
  ret i32 0
}

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #0

declare i32 @printf(i8*, ...)

declare i32 @putchar(i32)

define void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %visited, i64* %count) {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  %start_ge_n = icmp uge i64 %start, %n
  %bad = or i1 %n_is_zero, %start_ge_n
  br i1 %bad, label %early_ret, label %init_dist

early_ret:                                        ; preds = %alloc_queue, %entry
  store i64 0, i64* %count, align 8
  ret void

init_dist:                                        ; preds = %entry
  br label %dist_loop

dist_loop:                                        ; preds = %dist_body, %init_dist
  %i = phi i64 [ 0, %init_dist ], [ %i.next, %dist_body ]
  %dist_cond = icmp ult i64 %i, %n
  br i1 %dist_cond, label %dist_body, label %alloc_queue

dist_body:                                        ; preds = %dist_loop
  %dist_ptr_i = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist_ptr_i, align 4
  %i.next = add i64 %i, 1
  br label %dist_loop

alloc_queue:                                      ; preds = %dist_loop
  %size_bytes = shl i64 %n, 3
  %mem = call i8* @malloc(i64 %size_bytes)
  %queue = bitcast i8* %mem to i64*
  %is_null = icmp eq i64* %queue, null
  br i1 %is_null, label %early_ret, label %init_bfs

init_bfs:                                         ; preds = %alloc_queue
  %dist_start_ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist_start_ptr, align 4
  %q0 = getelementptr inbounds i64, i64* %queue, i64 0
  store i64 %start, i64* %q0, align 8
  store i64 0, i64* %count, align 8
  br label %bfs_loop

bfs_loop:                                         ; preds = %bfs_continue, %init_bfs
  %head = phi i64 [ 0, %init_bfs ], [ %head.next, %bfs_continue ]
  %tail = phi i64 [ 1, %init_bfs ], [ %tail.after, %bfs_continue ]
  %non_empty = icmp ult i64 %head, %tail
  br i1 %non_empty, label %dequeue, label %done_free

dequeue:                                          ; preds = %bfs_loop
  %u_ptr = getelementptr inbounds i64, i64* %queue, i64 %head
  %u = load i64, i64* %u_ptr, align 8
  %head.next = add i64 %head, 1
  %old_count = load i64, i64* %count, align 8
  %new_count = add i64 %old_count, 1
  store i64 %new_count, i64* %count, align 8
  %vis_slot = getelementptr inbounds i64, i64* %visited, i64 %old_count
  store i64 %u, i64* %vis_slot, align 8
  br label %inner_loop

inner_loop:                                       ; preds = %inner_step, %dequeue
  %v = phi i64 [ 0, %dequeue ], [ %v.next, %inner_step ]
  %tail.cur = phi i64 [ %tail, %dequeue ], [ %tail.updated, %inner_step ]
  %vcond = icmp ult i64 %v, %n
  br i1 %vcond, label %inner_body, label %after_inner

inner_body:                                       ; preds = %inner_loop
  %mul = mul i64 %u, %n
  %idx = add i64 %mul, %v
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %adj_val = load i32, i32* %adj_ptr, align 4
  %is_edge = icmp ne i32 %adj_val, 0
  br i1 %is_edge, label %check_unseen, label %no_enqueue

check_unseen:                                     ; preds = %inner_body
  %dist_v_ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %dist_v = load i32, i32* %dist_v_ptr, align 4
  %is_unseen = icmp eq i32 %dist_v, -1
  br i1 %is_unseen, label %do_enqueue, label %no_enqueue

do_enqueue:                                       ; preds = %check_unseen
  %dist_u_ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %dist_u = load i32, i32* %dist_u_ptr, align 4
  %dist_u_plus1 = add nsw i32 %dist_u, 1
  store i32 %dist_u_plus1, i32* %dist_v_ptr, align 4
  %queue_tail_ptr = getelementptr inbounds i64, i64* %queue, i64 %tail.cur
  store i64 %v, i64* %queue_tail_ptr, align 8
  %tail.inc = add i64 %tail.cur, 1
  br label %inner_step

no_enqueue:                                       ; preds = %check_unseen, %inner_body
  br label %inner_step

inner_step:                                       ; preds = %no_enqueue, %do_enqueue
  %tail.updated = phi i64 [ %tail.inc, %do_enqueue ], [ %tail.cur, %no_enqueue ]
  %v.next = add i64 %v, 1
  br label %inner_loop

after_inner:                                      ; preds = %inner_loop
  %tail.after = phi i64 [ %tail.cur, %inner_loop ]
  br label %bfs_continue

bfs_continue:                                     ; preds = %after_inner
  br label %bfs_loop

done_free:                                        ; preds = %bfs_loop
  call void @free(i8* %mem)
  ret void
}

declare noalias i8* @malloc(i64)

declare void @free(i8*)

attributes #0 = { argmemonly nofree nounwind willreturn writeonly }
