; ModuleID = 'dfs.ll'
target triple = "x86_64-unknown-linux-gnu"

declare noalias i8* @malloc(i64)
declare void @free(i8* nocapture)

define void @dfs(i32* %adj, i64 %n, i64 %start, i64* %out, i64* %out_len) {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  %start_ge_n = icmp uge i64 %start, %n
  %invalid = or i1 %n_is_zero, %start_ge_n
  br i1 %invalid, label %ret_zero, label %alloc

ret_zero:
  store i64 0, i64* %out_len, align 8
  br label %ret

alloc:
  %size4 = shl i64 %n, 2
  %m1 = call i8* @malloc(i64 %size4)
  %visited = bitcast i8* %m1 to i32*
  %size8 = shl i64 %n, 3
  %m2 = call i8* @malloc(i64 %size8)
  %next = bitcast i8* %m2 to i64*
  %m3 = call i8* @malloc(i64 %size8)
  %stack = bitcast i8* %m3 to i64*
  %vnull = icmp eq i32* %visited, null
  %nnull = icmp eq i64* %next, null
  %snull = icmp eq i64* %stack, null
  %tmp_or = or i1 %vnull, %nnull
  %anynull = or i1 %tmp_or, %snull
  br i1 %anynull, label %alloc_fail, label %init

alloc_fail:
  %v_i8 = bitcast i32* %visited to i8*
  call void @free(i8* %v_i8)
  %n_i8 = bitcast i64* %next to i8*
  call void @free(i8* %n_i8)
  %s_i8 = bitcast i64* %stack to i8*
  call void @free(i8* %s_i8)
  store i64 0, i64* %out_len, align 8
  br label %ret

init:
  br label %init_loop

init_loop:
  %i = phi i64 [ 0, %init ], [ %i_next, %init_body ]
  %more = icmp ult i64 %i, %n
  br i1 %more, label %init_body, label %after_init

init_body:
  %v_slot = getelementptr inbounds i32, i32* %visited, i64 %i
  store i32 0, i32* %v_slot, align 4
  %ni_slot = getelementptr inbounds i64, i64* %next, i64 %i
  store i64 0, i64* %ni_slot, align 8
  %i_next = add i64 %i, 1
  br label %init_loop

after_init:
  store i64 0, i64* %out_len, align 8
  %stk0 = getelementptr inbounds i64, i64* %stack, i64 0
  store i64 %start, i64* %stk0, align 8
  %vis_s = getelementptr inbounds i32, i32* %visited, i64 %start
  store i32 1, i32* %vis_s, align 4
  %len0 = load i64, i64* %out_len, align 8
  %len1 = add i64 %len0, 1
  store i64 %len1, i64* %out_len, align 8
  %out_slot0 = getelementptr inbounds i64, i64* %out, i64 %len0
  store i64 %start, i64* %out_slot0, align 8
  br label %outer_header

outer_header:
  %stack_size = phi i64 [ 1, %after_init ], [ %stack_size_next, %outer_cont ]
  %has = icmp ne i64 %stack_size, 0
  br i1 %has, label %have_stack, label %cleanup

have_stack:
  %ssm1 = add i64 %stack_size, -1
  %top_ptr = getelementptr inbounds i64, i64* %stack, i64 %ssm1
  %top = load i64, i64* %top_ptr, align 8
  %nxtptr = getelementptr inbounds i64, i64* %next, i64 %top
  %idx0 = load i64, i64* %nxtptr, align 8
  br label %inner_loop

inner_loop:
  %idx = phi i64 [ %idx0, %have_stack ], [ %idx_inc, %inner_body_failed ]
  %lt = icmp ult i64 %idx, %n
  br i1 %lt, label %inner_body, label %inner_exit

inner_body:
  %mul = mul i64 %top, %n
  %sum = add i64 %mul, %idx
  %a_ptr = getelementptr inbounds i32, i32* %adj, i64 %sum
  %edge = load i32, i32* %a_ptr, align 4
  %zero = icmp eq i32 %edge, 0
  br i1 %zero, label %inner_body_failed, label %check_vis

inner_body_failed:
  %idx_inc = add i64 %idx, 1
  br label %inner_loop

check_vis:
  %vptr2 = getelementptr inbounds i32, i32* %visited, i64 %idx
  %vval = load i32, i32* %vptr2, align 4
  %vis0 = icmp eq i32 %vval, 0
  br i1 %vis0, label %found, label %inner_body_failed

found:
  %idx1 = add i64 %idx, 1
  store i64 %idx1, i64* %nxtptr, align 8
  store i32 1, i32* %vptr2, align 4
  %olen = load i64, i64* %out_len, align 8
  %nlen = add i64 %olen, 1
  store i64 %nlen, i64* %out_len, align 8
  %oslot = getelementptr inbounds i64, i64* %out, i64 %olen
  store i64 %idx, i64* %oslot, align 8
  %push_slot = getelementptr inbounds i64, i64* %stack, i64 %stack_size
  store i64 %idx, i64* %push_slot, align 8
  %ss_push = add i64 %stack_size, 1
  br label %after_inner

inner_exit:
  br label %after_inner

after_inner:
  %idx_chk = phi i64 [ %idx, %inner_exit ], [ %idx, %found ]
  %ss_cur = phi i64 [ %stack_size, %inner_exit ], [ %ss_push, %found ]
  %eqn = icmp eq i64 %idx_chk, %n
  br i1 %eqn, label %pop, label %outer_cont

pop:
  %ss_pop = add i64 %ss_cur, -1
  br label %outer_cont

outer_cont:
  %stack_size_next = phi i64 [ %ss_pop, %pop ], [ %ss_cur, %after_inner ]
  br label %outer_header

cleanup:
  %v_i8_2 = bitcast i32* %visited to i8*
  call void @free(i8* %v_i8_2)
  %n_i8_2 = bitcast i64* %next to i8*
  call void @free(i8* %n_i8_2)
  %s_i8_2 = bitcast i64* %stack to i8*
  call void @free(i8* %s_i8_2)
  br label %ret

ret:
  ret void
}