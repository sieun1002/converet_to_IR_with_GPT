; ModuleID = 'DFS.bc'
source_filename = "llvm-link"
target triple = "x86_64-unknown-linux-gnu"

@.str_heading = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str_fmt = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %adj = alloca [49 x i32], align 16
  %out = alloca [64 x i64], align 16
  %out_len = alloca i64, align 8
  %start = alloca i64, align 8
  %N = alloca i64, align 8
  %i = alloca i64, align 8
  store i64 7, i64* %N, align 8
  store i64 0, i64* %start, align 8
  store i64 0, i64* %out_len, align 8
  %adj_i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj_i8, i8 0, i64 196, i1 false)
  %Nval = load i64, i64* %N, align 8
  %twoN = add i64 %Nval, %Nval
  %threeN = add i64 %twoN, %Nval
  %fourN = add i64 %twoN, %twoN
  %fiveN = add i64 %fourN, %Nval
  %sixN = add i64 %threeN, %threeN
  %p1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %p2, align 4
  %pN = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %Nval
  store i32 1, i32* %pN, align 4
  %p2N = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %twoN
  store i32 1, i32* %p2N, align 4
  %Nplus3 = add i64 %Nval, 3
  %pN3 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %Nplus3
  store i32 1, i32* %pN3, align 4
  %threeNplus1 = add i64 %threeN, 1
  %p3N1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %threeNplus1
  store i32 1, i32* %p3N1, align 4
  %Nplus4 = add i64 %Nval, 4
  %pN4 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %Nplus4
  store i32 1, i32* %pN4, align 4
  %fourNplus1 = add i64 %fourN, 1
  %p4N1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %fourNplus1
  store i32 1, i32* %p4N1, align 4
  %twoNplus5 = add i64 %twoN, 5
  %p2N5 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %twoNplus5
  store i32 1, i32* %p2N5, align 4
  %fiveNplus2 = add i64 %fiveN, 2
  %p5N2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %fiveNplus2
  store i32 1, i32* %p5N2, align 4
  %fourNplus5 = add i64 %fourN, 5
  %p4N5 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %fourNplus5
  store i32 1, i32* %p4N5, align 4
  %fiveNplus4 = add i64 %fiveN, 4
  %p5N4 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %fiveNplus4
  store i32 1, i32* %p5N4, align 4
  %fiveNplus6 = add i64 %fiveN, 6
  %p5N6 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %fiveNplus6
  store i32 1, i32* %p5N6, align 4
  %sixNplus5 = add i64 %sixN, 5
  %p6N5 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %sixNplus5
  store i32 1, i32* %p6N5, align 4
  %adj_ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %out_ptr = getelementptr inbounds [64 x i64], [64 x i64]* %out, i64 0, i64 0
  %start_val = load i64, i64* %start, align 8
  call void @dfs(i32* %adj_ptr, i64 %Nval, i64 %start_val, i64* %out_ptr, i64* %out_len)
  %fmt1 = getelementptr inbounds [24 x i8], [24 x i8]* @.str_heading, i64 0, i64 0
  %call0 = call i32 (i8*, ...) @printf(i8* %fmt1, i64 %start_val)
  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %i.cur = load i64, i64* %i, align 8
  %len = load i64, i64* %out_len, align 8
  %cmp = icmp ult i64 %i.cur, %len
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:                                        ; preds = %loop.cond
  %i.next = add i64 %i.cur, 1
  %has_more = icmp ult i64 %i.next, %len
  %space_ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  %empty_ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  %sep = select i1 %has_more, i8* %space_ptr, i8* %empty_ptr
  %elt_ptr = getelementptr inbounds [64 x i64], [64 x i64]* %out, i64 0, i64 %i.cur
  %elt = load i64, i64* %elt_ptr, align 8
  %fmt2 = getelementptr inbounds [6 x i8], [6 x i8]* @.str_fmt, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt2, i64 %elt, i8* %sep)
  store i64 %i.next, i64* %i, align 8
  br label %loop.cond

loop.end:                                         ; preds = %loop.cond
  %_ = call i32 @putchar(i32 10)
  ret i32 0
}

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #0

declare i32 @printf(i8*, ...)

declare i32 @putchar(i32)

define dso_local void @dfs(i32* %adj, i64 %n, i64 %start, i64* %out_path, i64* %out_len) {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  %start_ge_n = icmp uge i64 %start, %n
  %bad = or i1 %n_is_zero, %start_ge_n
  br i1 %bad, label %early_exit, label %allocs

early_exit:                                       ; preds = %entry
  store i64 0, i64* %out_len, align 8
  ret void

allocs:                                           ; preds = %entry
  %sz_vis = mul i64 %n, 4
  %vis_raw = call i8* @malloc(i64 %sz_vis)
  %visited = bitcast i8* %vis_raw to i32*
  %sz_q = shl i64 %n, 3
  %next_raw = call i8* @malloc(i64 %sz_q)
  %nextIdx = bitcast i8* %next_raw to i64*
  %stack_raw = call i8* @malloc(i64 %sz_q)
  %stack = bitcast i8* %stack_raw to i64*
  %vis_null = icmp eq i8* %vis_raw, null
  %next_null = icmp eq i8* %next_raw, null
  %stack_null = icmp eq i8* %stack_raw, null
  %any_null.tmp = or i1 %vis_null, %next_null
  %any_null = or i1 %any_null.tmp, %stack_null
  br i1 %any_null, label %alloc_fail, label %zero_init

alloc_fail:                                       ; preds = %allocs
  call void @free(i8* %vis_raw)
  call void @free(i8* %next_raw)
  call void @free(i8* %stack_raw)
  store i64 0, i64* %out_len, align 8
  ret void

zero_init:                                        ; preds = %allocs
  br label %zero_loop.header

zero_loop.header:                                 ; preds = %zero_loop.body, %zero_init
  %i = phi i64 [ 0, %zero_init ], [ %i.next, %zero_loop.body ]
  %cond.i = icmp ult i64 %i, %n
  br i1 %cond.i, label %zero_loop.body, label %after_init

zero_loop.body:                                   ; preds = %zero_loop.header
  %vis.ptr = getelementptr inbounds i32, i32* %visited, i64 %i
  store i32 0, i32* %vis.ptr, align 4
  %next.ptr = getelementptr inbounds i64, i64* %nextIdx, i64 %i
  store i64 0, i64* %next.ptr, align 8
  %i.next = add i64 %i, 1
  br label %zero_loop.header

after_init:                                       ; preds = %zero_loop.header
  store i64 0, i64* %out_len, align 8
  %stack.slot0 = getelementptr inbounds i64, i64* %stack, i64 0
  store i64 %start, i64* %stack.slot0, align 8
  %vis.start.ptr = getelementptr inbounds i32, i32* %visited, i64 %start
  store i32 1, i32* %vis.start.ptr, align 4
  %len0 = load i64, i64* %out_len, align 8
  %len1 = add i64 %len0, 1
  store i64 %len1, i64* %out_len, align 8
  %path.slot0 = getelementptr inbounds i64, i64* %out_path, i64 %len0
  store i64 %start, i64* %path.slot0, align 8
  br label %outer.header

outer.header:                                     ; preds = %after_inner, %inner.found, %after_init
  %size = phi i64 [ 1, %after_init ], [ %size.inc, %inner.found ], [ %size.dec, %after_inner ]
  %size_nz = icmp ne i64 %size, 0
  br i1 %size_nz, label %load_top, label %cleanup

load_top:                                         ; preds = %outer.header
  %size.minus1 = add i64 %size, -1
  %top.ptr = getelementptr inbounds i64, i64* %stack, i64 %size.minus1
  %v = load i64, i64* %top.ptr, align 8
  %next.v.ptr = getelementptr inbounds i64, i64* %nextIdx, i64 %v
  %j0 = load i64, i64* %next.v.ptr, align 8
  br label %inner.header

inner.header:                                     ; preds = %inner.inc_j, %load_top
  %j = phi i64 [ %j0, %load_top ], [ %j.next, %inner.inc_j ]
  %j_lt_n = icmp ult i64 %j, %n
  br i1 %j_lt_n, label %inner.check_adj, label %after_inner

inner.check_adj:                                  ; preds = %inner.header
  %vn = mul i64 %v, %n
  %idxM = add i64 %vn, %j
  %adj.ptr = getelementptr inbounds i32, i32* %adj, i64 %idxM
  %adj.val = load i32, i32* %adj.ptr, align 4
  %adj_zero = icmp eq i32 %adj.val, 0
  br i1 %adj_zero, label %inner.inc_j, label %check_visited

check_visited:                                    ; preds = %inner.check_adj
  %vis.j.ptr = getelementptr inbounds i32, i32* %visited, i64 %j
  %vis.j = load i32, i32* %vis.j.ptr, align 4
  %vis_j_nz = icmp ne i32 %vis.j, 0
  br i1 %vis_j_nz, label %inner.inc_j, label %inner.found

inner.inc_j:                                      ; preds = %check_visited, %inner.check_adj
  %j.next = add i64 %j, 1
  br label %inner.header

inner.found:                                      ; preds = %check_visited
  %j.plus1 = add i64 %j, 1
  store i64 %j.plus1, i64* %next.v.ptr, align 8
  store i32 1, i32* %vis.j.ptr, align 4
  %len.cur = load i64, i64* %out_len, align 8
  %len.new = add i64 %len.cur, 1
  store i64 %len.new, i64* %out_len, align 8
  %path.slot = getelementptr inbounds i64, i64* %out_path, i64 %len.cur
  store i64 %j, i64* %path.slot, align 8
  %push.ptr = getelementptr inbounds i64, i64* %stack, i64 %size
  store i64 %j, i64* %push.ptr, align 8
  %size.inc = add i64 %size, 1
  br label %outer.header

after_inner:                                      ; preds = %inner.header
  %size.dec = add i64 %size, -1
  br label %outer.header

cleanup:                                          ; preds = %outer.header
  call void @free(i8* %vis_raw)
  call void @free(i8* %next_raw)
  call void @free(i8* %stack_raw)
  ret void
}

declare noalias i8* @malloc(i64)

declare void @free(i8*)

attributes #0 = { argmemonly nofree nounwind willreturn writeonly }
