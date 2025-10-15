; ModuleID = 'bfs_module'
source_filename = "bfs.ll"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare dllimport i8* @malloc(i64)
declare dllimport void @free(i8*)

define dso_local void @bfs(i32* nocapture readonly %adj, i64 %n, i64 %start, i32* nocapture %dist, i64* nocapture %outOrder, i64* nocapture %pCount) local_unnamed_addr {
entry:
  %cmp_n_zero = icmp eq i64 %n, 0
  br i1 %cmp_n_zero, label %early_ret, label %check_start

check_start:
  %cmp_start = icmp ult i64 %start, %n
  br i1 %cmp_start, label %init_dist, label %early_ret

early_ret:
  store i64 0, i64* %pCount, align 8
  ret void

init_dist:
  store i64 0, i64* %pCount, align 8
  br label %dist_loop

dist_loop:
  %i = phi i64 [ 0, %init_dist ], [ %i_next, %dist_body_end ]
  %cmp_i_n = icmp ult i64 %i, %n
  br i1 %cmp_i_n, label %dist_body, label %malloc_block

dist_body:
  %dist_ptr_i = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist_ptr_i, align 4
  br label %dist_body_end

dist_body_end:
  %i_next = add i64 %i, 1
  br label %dist_loop

malloc_block:
  %size_bytes = shl i64 %n, 3
  %blk_raw = call i8* @malloc(i64 %size_bytes)
  %blk = bitcast i8* %blk_raw to i64*
  %blk_is_null = icmp eq i64* %blk, null
  br i1 %blk_is_null, label %early_ret, label %after_alloc

after_alloc:
  %dist_ptr_start = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist_ptr_start, align 4
  %idx_tail0 = getelementptr inbounds i64, i64* %blk, i64 0
  store i64 %start, i64* %idx_tail0, align 8
  br label %main_loop

main_loop:
  %head = phi i64 [ 0, %after_alloc ], [ %head_new, %after_inner_loop ]
  %tail = phi i64 [ 1, %after_alloc ], [ %tail_after, %after_inner_loop ]
  %cond_has = icmp ult i64 %head, %tail
  br i1 %cond_has, label %dequeue, label %free_and_ret

dequeue:
  %u_ptr = getelementptr inbounds i64, i64* %blk, i64 %head
  %u = load i64, i64* %u_ptr, align 8
  %count_old = load i64, i64* %pCount, align 8
  %count_new = add i64 %count_old, 1
  store i64 %count_new, i64* %pCount, align 8
  %out_ptr = getelementptr inbounds i64, i64* %outOrder, i64 %count_old
  store i64 %u, i64* %out_ptr, align 8
  br label %inner_loop

inner_loop:
  %v = phi i64 [ 0, %dequeue ], [ %v_next, %inner_continue ]
  %tail_acc = phi i64 [ %tail, %dequeue ], [ %tail_next, %inner_continue ]
  %cmp_vn = icmp ult i64 %v, %n
  br i1 %cmp_vn, label %inner_body, label %after_inner_loop

inner_body:
  %mul_un = mul i64 %u, %n
  %offset = add i64 %mul_un, %v
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %offset
  %val = load i32, i32* %adj_ptr, align 4
  %is_zero = icmp eq i32 %val, 0
  br i1 %is_zero, label %inner_continue, label %check_dist_v

check_dist_v:
  %dist_v_ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %dist_v = load i32, i32* %dist_v_ptr, align 4
  %cmp_neg1 = icmp eq i32 %dist_v, -1
  br i1 %cmp_neg1, label %visit_v, label %inner_continue

visit_v:
  %dist_u_ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %dist_u = load i32, i32* %dist_u_ptr, align 4
  %dist_u_plus1 = add i32 %dist_u, 1
  store i32 %dist_u_plus1, i32* %dist_v_ptr, align 4
  %tail_pos_ptr = getelementptr inbounds i64, i64* %blk, i64 %tail_acc
  store i64 %v, i64* %tail_pos_ptr, align 8
  %tail_inc = add i64 %tail_acc, 1
  br label %inner_continue

inner_continue:
  %tail_next = phi i64 [ %tail_inc, %visit_v ], [ %tail_acc, %inner_body ], [ %tail_acc, %check_dist_v ]
  %v_next = add i64 %v, 1
  br label %inner_loop

after_inner_loop:
  %tail_after = phi i64 [ %tail_acc, %inner_loop ]
  %head_new = add i64 %head, 1
  br label %main_loop

free_and_ret:
  %blk_i8 = bitcast i64* %blk to i8*
  call void @free(i8* %blk_i8)
  ret void
}