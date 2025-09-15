; ModuleID = 'DFS.bc'
source_filename = "llvm-link"
target triple = "x86_64-unknown-linux-gnu"

@.str.header = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str.item = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.sep = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1

define void @dfs(i32* %adj, i64 %n, i64 %start, i64* %out, i64* %out_len) {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  %start_ge_n = icmp uge i64 %start, %n
  %invalid = or i1 %n_is_zero, %start_ge_n
  br i1 %invalid, label %ret_zero, label %alloc

ret_zero:                                         ; preds = %entry
  store i64 0, i64* %out_len, align 8
  br label %ret

alloc:                                            ; preds = %entry
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

alloc_fail:                                       ; preds = %alloc
  %v_i8 = bitcast i32* %visited to i8*
  call void @free(i8* %v_i8)
  %n_i8 = bitcast i64* %next to i8*
  call void @free(i8* %n_i8)
  %s_i8 = bitcast i64* %stack to i8*
  call void @free(i8* %s_i8)
  store i64 0, i64* %out_len, align 8
  br label %ret

init:                                             ; preds = %alloc
  br label %init_loop

init_loop:                                        ; preds = %init_body, %init
  %i = phi i64 [ 0, %init ], [ %i_next, %init_body ]
  %more = icmp ult i64 %i, %n
  br i1 %more, label %init_body, label %after_init

init_body:                                        ; preds = %init_loop
  %v_slot = getelementptr inbounds i32, i32* %visited, i64 %i
  store i32 0, i32* %v_slot, align 4
  %ni_slot = getelementptr inbounds i64, i64* %next, i64 %i
  store i64 0, i64* %ni_slot, align 8
  %i_next = add i64 %i, 1
  br label %init_loop

after_init:                                       ; preds = %init_loop
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

outer_header:                                     ; preds = %outer_cont, %after_init
  %stack_size = phi i64 [ 1, %after_init ], [ %stack_size_next, %outer_cont ]
  %has = icmp ne i64 %stack_size, 0
  br i1 %has, label %have_stack, label %cleanup

have_stack:                                       ; preds = %outer_header
  %ssm1 = add i64 %stack_size, -1
  %top_ptr = getelementptr inbounds i64, i64* %stack, i64 %ssm1
  %top = load i64, i64* %top_ptr, align 8
  %nxtptr = getelementptr inbounds i64, i64* %next, i64 %top
  %idx0 = load i64, i64* %nxtptr, align 8
  br label %inner_loop

inner_loop:                                       ; preds = %inner_body_failed, %have_stack
  %idx = phi i64 [ %idx0, %have_stack ], [ %idx_inc, %inner_body_failed ]
  %lt = icmp ult i64 %idx, %n
  br i1 %lt, label %inner_body, label %inner_exit

inner_body:                                       ; preds = %inner_loop
  %mul = mul i64 %top, %n
  %sum = add i64 %mul, %idx
  %a_ptr = getelementptr inbounds i32, i32* %adj, i64 %sum
  %edge = load i32, i32* %a_ptr, align 4
  %zero = icmp eq i32 %edge, 0
  br i1 %zero, label %inner_body_failed, label %check_vis

inner_body_failed:                                ; preds = %check_vis, %inner_body
  %idx_inc = add i64 %idx, 1
  br label %inner_loop

check_vis:                                        ; preds = %inner_body
  %vptr2 = getelementptr inbounds i32, i32* %visited, i64 %idx
  %vval = load i32, i32* %vptr2, align 4
  %vis0 = icmp eq i32 %vval, 0
  br i1 %vis0, label %found, label %inner_body_failed

found:                                            ; preds = %check_vis
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

inner_exit:                                       ; preds = %inner_loop
  br label %after_inner

after_inner:                                      ; preds = %inner_exit, %found
  %idx_chk = phi i64 [ %idx, %inner_exit ], [ %idx, %found ]
  %ss_cur = phi i64 [ %stack_size, %inner_exit ], [ %ss_push, %found ]
  %eqn = icmp eq i64 %idx_chk, %n
  br i1 %eqn, label %pop, label %outer_cont

pop:                                              ; preds = %after_inner
  %ss_pop = add i64 %ss_cur, -1
  br label %outer_cont

outer_cont:                                       ; preds = %pop, %after_inner
  %stack_size_next = phi i64 [ %ss_pop, %pop ], [ %ss_cur, %after_inner ]
  br label %outer_header

cleanup:                                          ; preds = %outer_header
  %v_i8_2 = bitcast i32* %visited to i8*
  call void @free(i8* %v_i8_2)
  %n_i8_2 = bitcast i64* %next to i8*
  call void @free(i8* %n_i8_2)
  %s_i8_2 = bitcast i64* %stack to i8*
  call void @free(i8* %s_i8_2)
  br label %ret

ret:                                              ; preds = %cleanup, %alloc_fail, %ret_zero
  ret void
}

declare noalias i8* @malloc(i64)

declare void @free(i8* nocapture)

define i32 @main() {
entry:
  %matrix = alloca [49 x i32], align 16
  %out = alloca [7 x i64], align 16
  %n = alloca i64, align 8
  %start = alloca i64, align 8
  %out_len = alloca i64, align 8
  store i64 7, i64* %n, align 8
  %matrix.i8 = bitcast [49 x i32]* %matrix to i8*
  call void @llvm.memset.p0i8.i64(i8* %matrix.i8, i8 0, i64 196, i1 false)
  %gepa1 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 1
  store i32 1, i32* %gepa1, align 4
  %gepa7 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 7
  store i32 1, i32* %gepa7, align 4
  %gepa2 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 2
  store i32 1, i32* %gepa2, align 4
  %gepa14 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 14
  store i32 1, i32* %gepa14, align 4
  %gepa10 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 10
  store i32 1, i32* %gepa10, align 4
  %gepa22 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 22
  store i32 1, i32* %gepa22, align 4
  %gepa11 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 11
  store i32 1, i32* %gepa11, align 4
  %gepa29 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 29
  store i32 1, i32* %gepa29, align 4
  %gepa19 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 19
  store i32 1, i32* %gepa19, align 4
  %gepa37 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 37
  store i32 1, i32* %gepa37, align 4
  %gepa33 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 33
  store i32 1, i32* %gepa33, align 4
  %gepa39 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 39
  store i32 1, i32* %gepa39, align 4
  %gepa41 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 41
  store i32 1, i32* %gepa41, align 4
  %gepa47 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 47
  store i32 1, i32* %gepa47, align 4
  store i64 0, i64* %start, align 8
  store i64 0, i64* %out_len, align 8
  %mat.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 0
  %n.val = load i64, i64* %n, align 8
  %start.val = load i64, i64* %start, align 8
  %out.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %out, i64 0, i64 0
  call void @dfs(i32* %mat.ptr, i64 %n.val, i64 %start.val, i64* %out.ptr, i64* %out_len)
  %fmt.header.ptr = getelementptr inbounds [24 x i8], [24 x i8]* @.str.header, i64 0, i64 0
  %printf.hdr = call i32 (i8*, ...) @printf(i8* %fmt.header.ptr, i64 %start.val)
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %i.ph = phi i64 [ 0, %entry ], [ %i.next, %loop.body ]
  %len.cur = load i64, i64* %out_len, align 8
  %cmp.more = icmp ult i64 %i.ph, %len.cur
  br i1 %cmp.more, label %loop.body, label %loop.end

loop.body:                                        ; preds = %loop.cond
  %next.idx = add i64 %i.ph, 1
  %len.again = load i64, i64* %out_len, align 8
  %has.sep = icmp ult i64 %next.idx, %len.again
  %sep.space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.sep, i64 0, i64 0
  %sep.empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  %sep.ptr = select i1 %has.sep, i8* %sep.space.ptr, i8* %sep.empty.ptr
  %out.elem.ptr2 = getelementptr inbounds [7 x i64], [7 x i64]* %out, i64 0, i64 %i.ph
  %out.val = load i64, i64* %out.elem.ptr2, align 8
  %fmt.item.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str.item, i64 0, i64 0
  %printf.it = call i32 (i8*, ...) @printf(i8* %fmt.item.ptr, i64 %out.val, i8* %sep.ptr)
  %i.next = add i64 %i.ph, 1
  br label %loop.cond

loop.end:                                         ; preds = %loop.cond
  %putc = call i32 @putchar(i32 10)
  ret i32 0
}

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #0

declare i32 @printf(i8* noundef, ...)

declare i32 @putchar(i32 noundef)

attributes #0 = { argmemonly nofree nounwind willreturn writeonly }
