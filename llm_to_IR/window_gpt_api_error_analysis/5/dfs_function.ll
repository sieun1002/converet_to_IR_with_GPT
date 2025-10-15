; ModuleID = 'dfs_module'
target triple = "x86_64-pc-windows-msvc"

declare i8* @malloc(i64)
declare void @free(i8*)

define void @dfs(i32* %adj, i64 %n, i64 %start, i64* %out, i64* %pcount) {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  br i1 %n_is_zero, label %early_zero, label %check_start

early_zero:
  store i64 0, i64* %pcount, align 8
  br label %ret

check_start:
  %start_ge_n = icmp uge i64 %start, %n
  br i1 %start_ge_n, label %early_zero2, label %alloc

early_zero2:
  store i64 0, i64* %pcount, align 8
  br label %ret

alloc:
  %size_block = shl i64 %n, 2
  %mem_block_i8 = call i8* @malloc(i64 %size_block)
  %mem_block_null = icmp eq i8* %mem_block_i8, null
  %size64 = shl i64 %n, 3
  %mem_next_i8 = call i8* @malloc(i64 %size64)
  %mem_next_null = icmp eq i8* %mem_next_i8, null
  %mem_stack_i8 = call i8* @malloc(i64 %size64)
  %mem_stack_null = icmp eq i8* %mem_stack_i8, null
  %any_null1 = or i1 %mem_block_null, %mem_next_null
  %any_null = or i1 %any_null1, %mem_stack_null
  br i1 %any_null, label %alloc_fail, label %after_alloc

alloc_fail:
  call void @free(i8* %mem_block_i8)
  call void @free(i8* %mem_next_i8)
  call void @free(i8* %mem_stack_i8)
  store i64 0, i64* %pcount, align 8
  br label %ret

after_alloc:
  %visited = bitcast i8* %mem_block_i8 to i32*
  %next = bitcast i8* %mem_next_i8 to i64*
  %stack = bitcast i8* %mem_stack_i8 to i64*
  br label %init_loop

init_loop:
  %i = phi i64 [ 0, %after_alloc ], [ %i.next, %init_loop_body ]
  %cond = icmp ult i64 %i, %n
  br i1 %cond, label %init_loop_body, label %post_init

init_loop_body:
  %visited_gep = getelementptr inbounds i32, i32* %visited, i64 %i
  store i32 0, i32* %visited_gep, align 4
  %next_gep = getelementptr inbounds i64, i64* %next, i64 %i
  store i64 0, i64* %next_gep, align 8
  %i.next = add i64 %i, 1
  br label %init_loop

post_init:
  store i64 0, i64* %pcount, align 8
  %stack0 = getelementptr inbounds i64, i64* %stack, i64 0
  store i64 %start, i64* %stack0, align 8
  br label %after_first_push

after_first_push:
  %v_idx = getelementptr inbounds i32, i32* %visited, i64 %start
  store i32 1, i32* %v_idx, align 4
  %oldcnt = load i64, i64* %pcount, align 8
  %oldidx8 = getelementptr inbounds i64, i64* %out, i64 %oldcnt
  store i64 %start, i64* %oldidx8, align 8
  %newcnt = add i64 %oldcnt, 1
  store i64 %newcnt, i64* %pcount, align 8
  br label %outer_loop

outer_loop:
  %ss = phi i64 [ 1, %after_first_push ], [ %ss2, %pop_or_continue ]
  %ss_zero = icmp eq i64 %ss, 0
  br i1 %ss_zero, label %done_loop, label %process_top

process_top:
  %ss_minus1 = add i64 %ss, -1
  %stack_top_ptr = getelementptr inbounds i64, i64* %stack, i64 %ss_minus1
  %top = load i64, i64* %stack_top_ptr, align 8
  %next_ptr = getelementptr inbounds i64, i64* %next, i64 %top
  %idx0 = load i64, i64* %next_ptr, align 8
  br label %inner_loop

inner_loop:
  %idx = phi i64 [ %idx0, %process_top ], [ %idx.inc, %inner_continue ]
  %idx_lt_n = icmp ult i64 %idx, %n
  br i1 %idx_lt_n, label %check_edge, label %inner_done

check_edge:
  %mul = mul i64 %top, %n
  %sum = add i64 %mul, %idx
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %sum
  %val = load i32, i32* %adj_ptr, align 4
  %is_zero = icmp eq i32 %val, 0
  br i1 %is_zero, label %inner_continue, label %check_visited

inner_continue:
  %idx.inc = add i64 %idx, 1
  br label %inner_loop

check_visited:
  %v_ptr = getelementptr inbounds i32, i32* %visited, i64 %idx
  %v_load = load i32, i32* %v_ptr, align 4
  %v_is_zero = icmp eq i32 %v_load, 0
  br i1 %v_is_zero, label %push_new, label %inner_continue

push_new:
  %idx_plus1 = add i64 %idx, 1
  store i64 %idx_plus1, i64* %next_ptr, align 8
  store i32 1, i32* %v_ptr, align 4
  %oldcnt2 = load i64, i64* %pcount, align 8
  %pos_ptr = getelementptr inbounds i64, i64* %out, i64 %oldcnt2
  store i64 %idx, i64* %pos_ptr, align 8
  %newcnt2 = add i64 %oldcnt2, 1
  store i64 %newcnt2, i64* %pcount, align 8
  %stack_push_ptr = getelementptr inbounds i64, i64* %stack, i64 %ss
  store i64 %idx, i64* %stack_push_ptr, align 8
  %ss_pushed = add i64 %ss, 1
  br label %inner_done_ss

inner_done:
  br label %inner_done_ss

inner_done_ss:
  %idx_end = phi i64 [ %idx, %inner_done ], [ %idx, %push_new ]
  %ss_end = phi i64 [ %ss, %inner_done ], [ %ss_pushed, %push_new ]
  %idx_eq_n = icmp eq i64 %idx_end, %n
  br i1 %idx_eq_n, label %do_pop, label %no_pop

do_pop:
  %ss_dec = add i64 %ss_end, -1
  br label %pop_or_continue

no_pop:
  br label %pop_or_continue

pop_or_continue:
  %ss2 = phi i64 [ %ss_dec, %do_pop ], [ %ss_end, %no_pop ]
  br label %outer_loop

done_loop:
  call void @free(i8* %mem_block_i8)
  call void @free(i8* %mem_next_i8)
  call void @free(i8* %mem_stack_i8)
  br label %ret

ret:
  ret void
}