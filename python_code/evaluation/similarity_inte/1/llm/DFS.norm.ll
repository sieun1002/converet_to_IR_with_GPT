; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/integration/bc/1/DFS.ll'
source_filename = "llvm-link"
target triple = "x86_64-unknown-linux-gnu"

@.str.header = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str.item = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.sep = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1

define void @dfs(i32* %adj, i64 %n, i64 %start, i64* %out, i64* %out_len) {
entry:
  %start_ge_n.not = icmp ult i64 %start, %n
  br i1 %start_ge_n.not, label %alloc, label %ret_zero

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
  %vnull = icmp eq i8* %m1, null
  %nnull = icmp eq i8* %m2, null
  %snull = icmp eq i8* %m3, null
  %tmp_or = or i1 %vnull, %nnull
  %anynull = or i1 %tmp_or, %snull
  br i1 %anynull, label %alloc_fail, label %init_loop

alloc_fail:                                       ; preds = %alloc
  call void @free(i8* %m1)
  call void @free(i8* %m2)
  call void @free(i8* %m3)
  store i64 0, i64* %out_len, align 8
  br label %ret

init_loop:                                        ; preds = %alloc, %init_body
  %i = phi i64 [ %i_next, %init_body ], [ 0, %alloc ]
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
  store i64 %start, i64* %stack, align 8
  %vis_s = getelementptr inbounds i32, i32* %visited, i64 %start
  store i32 1, i32* %vis_s, align 4
  store i64 1, i64* %out_len, align 8
  store i64 %start, i64* %out, align 8
  br label %outer_header

outer_header:                                     ; preds = %after_inner, %after_init
  %stack_size = phi i64 [ 1, %after_init ], [ %spec.select, %after_inner ]
  %has.not = icmp eq i64 %stack_size, 0
  br i1 %has.not, label %cleanup, label %have_stack

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
  br i1 %lt, label %inner_body, label %after_inner

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
  %.pre = add i64 %ss_push, -1
  br label %after_inner

after_inner:                                      ; preds = %inner_loop, %found
  %ss_pop.pre-phi = phi i64 [ %ssm1, %inner_loop ], [ %.pre, %found ]
  %ss_cur = phi i64 [ %ss_push, %found ], [ %stack_size, %inner_loop ]
  %eqn = icmp eq i64 %idx, %n
  %spec.select = select i1 %eqn, i64 %ss_pop.pre-phi, i64 %ss_cur
  br label %outer_header

cleanup:                                          ; preds = %outer_header
  call void @free(i8* %m1)
  call void @free(i8* %m2)
  call void @free(i8* %m3)
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
  %out_len = alloca i64, align 8
  %matrix.i8 = bitcast [49 x i32]* %matrix to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(196) %matrix.i8, i8 0, i64 196, i1 false)
  %gepa1 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 1
  store i32 1, i32* %gepa1, align 4
  %gepa7 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 7
  store i32 1, i32* %gepa7, align 4
  %gepa2 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 2
  store i32 1, i32* %gepa2, align 8
  %gepa14 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 14
  store i32 1, i32* %gepa14, align 8
  %gepa10 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 10
  store i32 1, i32* %gepa10, align 8
  %gepa22 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 22
  store i32 1, i32* %gepa22, align 8
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
  store i64 0, i64* %out_len, align 8
  %mat.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 0
  %out.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %out, i64 0, i64 0
  call void @dfs(i32* nonnull %mat.ptr, i64 7, i64 0, i64* nonnull %out.ptr, i64* nonnull %out_len)
  %printf.hdr = call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([24 x i8], [24 x i8]* @.str.header, i64 0, i64 0), i64 0)
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %i.ph = phi i64 [ 0, %entry ], [ %next.idx, %loop.body ]
  %len.cur = load i64, i64* %out_len, align 8
  %cmp.more = icmp ult i64 %i.ph, %len.cur
  br i1 %cmp.more, label %loop.body, label %loop.end

loop.body:                                        ; preds = %loop.cond
  %next.idx = add i64 %i.ph, 1
  %has.sep = icmp ult i64 %next.idx, %len.cur
  %sep.ptr = select i1 %has.sep, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.sep, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0)
  %out.elem.ptr2 = getelementptr inbounds [7 x i64], [7 x i64]* %out, i64 0, i64 %i.ph
  %out.val = load i64, i64* %out.elem.ptr2, align 8
  %printf.it = call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([6 x i8], [6 x i8]* @.str.item, i64 0, i64 0), i64 %out.val, i8* %sep.ptr)
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
