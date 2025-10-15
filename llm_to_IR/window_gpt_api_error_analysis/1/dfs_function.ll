; ModuleID = 'dfs_module'
source_filename = "dfs_module"
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

declare dllimport i8* @malloc(i64)
declare dllimport void @free(i8*)

define void @dfs(i32* %adj, i64 %n, i64 %start, i64* %out, i64* %pCount) local_unnamed_addr nounwind {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  %start_oob = icmp uge i64 %start, %n
  %early_or = or i1 %n_is_zero, %start_oob
  br i1 %early_or, label %early_ret, label %allocs

early_ret:
  store i64 0, i64* %pCount, align 8
  ret void

allocs:
  %size_blk = mul i64 %n, 4
  %blk_raw = call i8* @malloc(i64 %size_blk)
  %blk = bitcast i8* %blk_raw to i32*
  %size_q = mul i64 %n, 8
  %next_raw = call i8* @malloc(i64 %size_q)
  %next = bitcast i8* %next_raw to i64*
  %stack_raw = call i8* @malloc(i64 %size_q)
  %stack = bitcast i8* %stack_raw to i64*
  %chk_blk = icmp eq i8* %blk_raw, null
  %chk_next = icmp eq i8* %next_raw, null
  %chk_stack = icmp eq i8* %stack_raw, null
  %any_null_t = or i1 %chk_blk, %chk_next
  %any_null = or i1 %any_null_t, %chk_stack
  br i1 %any_null, label %alloc_fail, label %init_loop

alloc_fail:
  call void @free(i8* %blk_raw)
  call void @free(i8* %next_raw)
  call void @free(i8* %stack_raw)
  store i64 0, i64* %pCount, align 8
  ret void

init_loop:
  %i0 = phi i64 [ 0, %allocs ], [ %i.next, %init_body ]
  %cond_init = icmp ult i64 %i0, %n
  br i1 %cond_init, label %init_body, label %after_init

init_body:
  %blk_gep = getelementptr inbounds i32, i32* %blk, i64 %i0
  store i32 0, i32* %blk_gep, align 4
  %next_gep = getelementptr inbounds i64, i64* %next, i64 %i0
  store i64 0, i64* %next_gep, align 8
  %i.next = add i64 %i0, 1
  br label %init_loop

after_init:
  store i64 0, i64* %pCount, align 8
  %sp0 = add i64 0, 0
  %old_sp = add i64 %sp0, 0
  %sp1 = add i64 %sp0, 1
  %stack_slot0 = getelementptr inbounds i64, i64* %stack, i64 %old_sp
  store i64 %start, i64* %stack_slot0, align 8
  %blk_start_gep = getelementptr inbounds i32, i32* %blk, i64 %start
  store i32 1, i32* %blk_start_gep, align 4
  %oldc0 = load i64, i64* %pCount, align 8
  %newc0 = add i64 %oldc0, 1
  store i64 %newc0, i64* %pCount, align 8
  %out_gep0 = getelementptr inbounds i64, i64* %out, i64 %oldc0
  store i64 %start, i64* %out_gep0, align 8
  br label %outer_check

outer_check:
  %sp = phi i64 [ %sp1, %after_init ], [ %sp_push, %neighbor_found ], [ %sp_dec, %after_inner ]
  %sp_nonzero = icmp ne i64 %sp, 0
  br i1 %sp_nonzero, label %prepare_inner, label %cleanup

prepare_inner:
  %sp_minus1 = add i64 %sp, -1
  %top_gep = getelementptr inbounds i64, i64* %stack, i64 %sp_minus1
  %current = load i64, i64* %top_gep, align 8
  %next_idx_ptr = getelementptr inbounds i64, i64* %next, i64 %current
  %next_val0 = load i64, i64* %next_idx_ptr, align 8
  br label %inner_loop

inner_loop:
  %next_it = phi i64 [ %next_val0, %prepare_inner ], [ %next_inc, %incr_next ]
  %lt_n = icmp ult i64 %next_it, %n
  br i1 %lt_n, label %test_edge, label %after_inner

test_edge:
  %mul = mul i64 %current, %n
  %idx = add i64 %mul, %next_it
  %adj_gep = getelementptr inbounds i32, i32* %adj, i64 %idx
  %adj_val = load i32, i32* %adj_gep, align 4
  %edge_nonzero = icmp ne i32 %adj_val, 0
  br i1 %edge_nonzero, label %check_visited, label %incr_next

check_visited:
  %vis_gep = getelementptr inbounds i32, i32* %blk, i64 %next_it
  %vis_val = load i32, i32* %vis_gep, align 4
  %unvisited = icmp eq i32 %vis_val, 0
  br i1 %unvisited, label %neighbor_found, label %incr_next

neighbor_found:
  %next_plus1 = add i64 %next_it, 1
  store i64 %next_plus1, i64* %next_idx_ptr, align 8
  store i32 1, i32* %vis_gep, align 4
  %oldc1 = load i64, i64* %pCount, align 8
  %newc1 = add i64 %oldc1, 1
  store i64 %newc1, i64* %pCount, align 8
  %out_gep1 = getelementptr inbounds i64, i64* %out, i64 %oldc1
  store i64 %next_it, i64* %out_gep1, align 8
  %old_sp2 = add i64 %sp, 0
  %sp_push = add i64 %sp, 1
  %stack_slot_push = getelementptr inbounds i64, i64* %stack, i64 %old_sp2
  store i64 %next_it, i64* %stack_slot_push, align 8
  br label %outer_check

incr_next:
  %next_inc = add i64 %next_it, 1
  br label %inner_loop

after_inner:
  %sp_dec = add i64 %sp, -1
  br label %outer_check

cleanup:
  call void @free(i8* %blk_raw)
  call void @free(i8* %next_raw)
  call void @free(i8* %stack_raw)
  ret void
}