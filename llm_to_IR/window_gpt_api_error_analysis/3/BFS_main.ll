; ModuleID = 'bfs_windows_msvc'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@_Format = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@asc_140004015 = private unnamed_addr constant [2 x i8] c" \00", align 1
@unk_140004017 = private unnamed_addr constant [1 x i8] c"\00", align 1
@aZuS = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@aDistZuZuD = private unnamed_addr constant [24 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define void @bfs(i32* %adj, i64 %n, i64 %start, i64* %order_out, i64* %order_len_out, i32* %dist_out) {
entry:
  %visited = alloca i8, i64 %n, align 1
  %queue = alloca i64, i64 %n, align 8
  %head = alloca i64, align 8
  %tail = alloca i64, align 8
  %ordlen = alloca i64, align 8
  %i_init = alloca i64, align 8
  store i64 0, i64* %i_init, align 8
  br label %init_loop

init_loop:
  %i_val = load i64, i64* %i_init, align 8
  %cmp_i = icmp ult i64 %i_val, %n
  br i1 %cmp_i, label %init_body, label %init_done

init_body:
  %vptr = getelementptr inbounds i8, i8* %visited, i64 %i_val
  store i8 0, i8* %vptr, align 1
  %dptr = getelementptr inbounds i32, i32* %dist_out, i64 %i_val
  store i32 -1, i32* %dptr, align 4
  %i_next = add i64 %i_val, 1
  store i64 %i_next, i64* %i_init, align 8
  br label %init_loop

init_done:
  store i64 0, i64* %head, align 8
  store i64 0, i64* %tail, align 8
  store i64 0, i64* %ordlen, align 8
  %start_vptr = getelementptr inbounds i8, i8* %visited, i64 %start
  store i8 1, i8* %start_vptr, align 1
  %start_dptr = getelementptr inbounds i32, i32* %dist_out, i64 %start
  store i32 0, i32* %start_dptr, align 4
  %tail0 = load i64, i64* %tail, align 8
  %qstartptr = getelementptr inbounds i64, i64* %queue, i64 %tail0
  store i64 %start, i64* %qstartptr, align 8
  %tail1 = add i64 %tail0, 1
  store i64 %tail1, i64* %tail, align 8
  br label %bfs_loop

bfs_loop:
  %hcur = load i64, i64* %head, align 8
  %tcur = load i64, i64* %tail, align 8
  %not_empty = icmp ult i64 %hcur, %tcur
  br i1 %not_empty, label %dequeue, label %bfs_done

dequeue:
  %uptr = getelementptr inbounds i64, i64* %queue, i64 %hcur
  %u = load i64, i64* %uptr, align 8
  %hnext = add i64 %hcur, 1
  store i64 %hnext, i64* %head, align 8
  %olen = load i64, i64* %ordlen, align 8
  %optr = getelementptr inbounds i64, i64* %order_out, i64 %olen
  store i64 %u, i64* %optr, align 8
  %olen1 = add i64 %olen, 1
  store i64 %olen1, i64* %ordlen, align 8
  %v_init = alloca i64, align 8
  store i64 0, i64* %v_init, align 8
  br label %nbr_loop

nbr_loop:
  %vcur = load i64, i64* %v_init, align 8
  %vcond = icmp ult i64 %vcur, %n
  br i1 %vcond, label %nbr_body, label %bfs_loop

nbr_body:
  %mul = mul i64 %u, %n
  %idx = add i64 %mul, %vcur
  %adjptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %aval = load i32, i32* %adjptr, align 4
  %a_nonzero = icmp ne i32 %aval, 0
  br i1 %a_nonzero, label %check_visit, label %next_v

check_visit:
  %vflagptr = getelementptr inbounds i8, i8* %visited, i64 %vcur
  %vflag = load i8, i8* %vflagptr, align 1
  %is_unvisited = icmp eq i8 %vflag, 0
  br i1 %is_unvisited, label %enqueue_v, label %next_v

enqueue_v:
  store i8 1, i8* %vflagptr, align 1
  %duptr = getelementptr inbounds i32, i32* %dist_out, i64 %u
  %du = load i32, i32* %duptr, align 4
  %dup1 = add i32 %du, 1
  %dvptr = getelementptr inbounds i32, i32* %dist_out, i64 %vcur
  store i32 %dup1, i32* %dvptr, align 4
  %tcur2 = load i64, i64* %tail, align 8
  %qvptr = getelementptr inbounds i64, i64* %queue, i64 %tcur2
  store i64 %vcur, i64* %qvptr, align 8
  %tinc = add i64 %tcur2, 1
  store i64 %tinc, i64* %tail, align 8
  br label %next_v

next_v:
  %vnext = add i64 %vcur, 1
  store i64 %vnext, i64* %v_init, align 8
  br label %nbr_loop

bfs_done:
  %final_len = load i64, i64* %ordlen, align 8
  store i64 %final_len, i64* %order_len_out, align 8
  ret void
}

define i32 @main(i32 %argc, i8** %argv) {
entry:
  %n = alloca i64, align 8
  %adj = alloca [49 x i32], align 16
  %order = alloca [7 x i64], align 16
  %order_len = alloca i64, align 8
  %dist = alloca [7 x i32], align 16
  store i64 7, i64* %n, align 8
  %adj0 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %i = alloca i64, align 8
  store i64 0, i64* %i, align 8
  br label %zero_loop

zero_loop:
  %i_val = load i64, i64* %i, align 8
  %i_cmp = icmp ult i64 %i_val, 49
  br i1 %i_cmp, label %zero_body, label %zero_done

zero_body:
  %cell = getelementptr inbounds i32, i32* %adj0, i64 %i_val
  store i32 0, i32* %cell, align 4
  %i_next = add i64 %i_val, 1
  store i64 %i_next, i64* %i, align 8
  br label %zero_loop

zero_done:
  %p1 = getelementptr inbounds i32, i32* %adj0, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %adj0, i64 2
  store i32 1, i32* %p2, align 4
  %p7 = getelementptr inbounds i32, i32* %adj0, i64 7
  store i32 1, i32* %p7, align 4
  %p10 = getelementptr inbounds i32, i32* %adj0, i64 10
  store i32 1, i32* %p10, align 4
  %p11 = getelementptr inbounds i32, i32* %adj0, i64 11
  store i32 1, i32* %p11, align 4
  %p14 = getelementptr inbounds i32, i32* %adj0, i64 14
  store i32 1, i32* %p14, align 4
  %p19 = getelementptr inbounds i32, i32* %adj0, i64 19
  store i32 1, i32* %p19, align 4
  %p22 = getelementptr inbounds i32, i32* %adj0, i64 22
  store i32 1, i32* %p22, align 4
  %p29 = getelementptr inbounds i32, i32* %adj0, i64 29
  store i32 1, i32* %p29, align 4
  %p33 = getelementptr inbounds i32, i32* %adj0, i64 33
  store i32 1, i32* %p33, align 4
  %p37 = getelementptr inbounds i32, i32* %adj0, i64 37
  store i32 1, i32* %p37, align 4
  %p39 = getelementptr inbounds i32, i32* %adj0, i64 39
  store i32 1, i32* %p39, align 4
  %p41 = getelementptr inbounds i32, i32* %adj0, i64 41
  store i32 1, i32* %p41, align 4
  %p47 = getelementptr inbounds i32, i32* %adj0, i64 47
  store i32 1, i32* %p47, align 4
  store i64 0, i64* %order_len, align 8
  %adjptr2 = bitcast [49 x i32]* %adj to i32*
  %order0 = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  %dist0 = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  call void @bfs(i32* %adjptr2, i64 7, i64 0, i64* %order0, i64* %order_len, i32* %dist0)
  %fmt_hdr = getelementptr inbounds [21 x i8], [21 x i8]* @_Format, i64 0, i64 0
  %start_val = load i64, i64* %n, align 8
  %src0 = sub i64 %start_val, 7
  %src_fix = add i64 %src0, 7
  %call_hdr = call i32 (i8*, ...) @printf(i8* %fmt_hdr, i64 0)
  %i2 = alloca i64, align 8
  store i64 0, i64* %i2, align 8
  br label %print_loop

print_loop:
  %i2v = load i64, i64* %i2, align 8
  %olen_read = load i64, i64* %order_len, align 8
  %cond = icmp ult i64 %i2v, %olen_read
  br i1 %cond, label %print_body, label %print_done

print_body:
  %plus1 = add i64 %i2v, 1
  %less = icmp ult i64 %plus1, %olen_read
  br i1 %less, label %space_sel, label %empty_sel

space_sel:
  %sep_space = getelementptr inbounds [2 x i8], [2 x i8]* @asc_140004015, i64 0, i64 0
  br label %sel_join

empty_sel:
  %sep_empty = getelementptr inbounds [1 x i8], [1 x i8]* @unk_140004017, i64 0, i64 0
  br label %sel_join

sel_join:
  %selphi = phi i8* [ %sep_space, %space_sel ], [ %sep_empty, %empty_sel ]
  %ordvalptr = getelementptr inbounds i64, i64* %order0, i64 %i2v
  %ordval = load i64, i64* %ordvalptr, align 8
  %fmt2 = getelementptr inbounds [6 x i8], [6 x i8]* @aZuS, i64 0, i64 0
  %call_print = call i32 (i8*, ...) @printf(i8* %fmt2, i64 %ordval, i8* %selphi)
  %i2next = add i64 %i2v, 1
  store i64 %i2next, i64* %i2, align 8
  br label %print_loop

print_done:
  %nl = call i32 @putchar(i32 10)
  %j = alloca i64, align 8
  store i64 0, i64* %j, align 8
  br label %dist_loop

dist_loop:
  %jv = load i64, i64* %j, align 8
  %condj = icmp ult i64 %jv, 7
  br i1 %condj, label %dist_body, label %ret

dist_body:
  %dptr2 = getelementptr inbounds i32, i32* %dist0, i64 %jv
  %dval = load i32, i32* %dptr2, align 4
  %fmt3 = getelementptr inbounds [24 x i8], [24 x i8]* @aDistZuZuD, i64 0, i64 0
  %print_dist = call i32 (i8*, ...) @printf(i8* %fmt3, i64 0, i64 %jv, i32 %dval)
  %jnext = add i64 %jv, 1
  store i64 %jnext, i64* %j, align 8
  br label %dist_loop

ret:
  ret i32 0
}