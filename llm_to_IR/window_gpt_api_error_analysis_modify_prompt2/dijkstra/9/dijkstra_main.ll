; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@_Format = private unnamed_addr constant [24 x i8] c"dist(%zu -> %zu) = INF\0A\00", align 1
@aDistZuZuD = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1
@aNoPathFromZuTo = private unnamed_addr constant [25 x i8] c"no path from %zu to %zu\0A\00", align 1
@aPathZuZu = private unnamed_addr constant [17 x i8] c"path %zu -> %zu:\00", align 1
@asc_140004059 = private unnamed_addr constant [4 x i8] c" ->\00", align 1
@unk_14000405D = private unnamed_addr constant [1 x i8] c"\00", align 1
@aZuS = private unnamed_addr constant [7 x i8] c" %zu%s\00", align 1

declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @putchar(i32)
declare dso_local void @dijkstra(i32*, ...)

define dso_local i32 @main() {
entry:
  %graph = alloca [36 x i32], align 16
  %dist = alloca [6 x i32], align 16
  %pred = alloca [6 x i32], align 16
  %path = alloca [6 x i64], align 16
  %var38 = alloca i64, align 8
  %var8 = alloca i64, align 8
  %var10 = alloca i64, align 8
  %var40 = alloca i64, align 8
  %var18 = alloca i64, align 8
  %var48 = alloca i64, align 8
  %var20 = alloca i64, align 8
  %var24 = alloca i32, align 4
  %var30 = alloca i64, align 8
  %var50 = alloca i64, align 8
  store i64 6, i64* %var38, align 8
  store i64 0, i64* %var8, align 8
  br label %fill_loop

fill_loop:                                         ; i = var8; while i < n*n: graph[i] = -1
  %i0 = load i64, i64* %var8, align 8
  %n0 = load i64, i64* %var38, align 8
  %n2 = mul i64 %n0, %n0
  %cmpfill = icmp ult i64 %i0, %n2
  br i1 %cmpfill, label %fill_body, label %fill_end

fill_body:
  %gep_fill = getelementptr inbounds [36 x i32], [36 x i32]* %graph, i64 0, i64 %i0
  store i32 -1, i32* %gep_fill, align 4
  %i1 = add i64 %i0, 1
  store i64 %i1, i64* %var8, align 8
  br label %fill_loop

fill_end:
  store i64 0, i64* %var10, align 8
  br label %diag_loop

diag_loop:                                         ; i = var10; while i < n: graph[i*(n+1)] = 0
  %di_i = load i64, i64* %var10, align 8
  %di_n = load i64, i64* %var38, align 8
  %cmpdiag = icmp ult i64 %di_i, %di_n
  br i1 %cmpdiag, label %diag_body, label %after_diag

diag_body:
  %np1 = add i64 %di_n, 1
  %idxd = mul i64 %di_i, %np1
  %gep_d = getelementptr inbounds [36 x i32], [36 x i32]* %graph, i64 0, i64 %idxd
  store i32 0, i32* %gep_d, align 4
  %di_inc = add i64 %di_i, 1
  store i64 %di_inc, i64* %var10, align 8
  br label %diag_loop

after_diag:
  %nA = load i64, i64* %var38, align 8
  %idx1 = add i64 %nA, 0
  %p1 = getelementptr inbounds [36 x i32], [36 x i32]* %graph, i64 0, i64 %idx1
  store i32 7, i32* %p1, align 4
  %twoN = shl i64 %nA, 1
  %p2 = getelementptr inbounds [36 x i32], [36 x i32]* %graph, i64 0, i64 %twoN
  store i32 9, i32* %p2, align 4
  %threeN = add i64 %twoN, %nA
  %p3 = getelementptr inbounds [36 x i32], [36 x i32]* %graph, i64 0, i64 %threeN
  store i32 10, i32* %p3, align 4
  %idx4 = add i64 %nA, 3
  %p4 = getelementptr inbounds [36 x i32], [36 x i32]* %graph, i64 0, i64 %idx4
  store i32 15, i32* %p4, align 4
  %idx5 = add i64 %threeN, 1
  %p5 = getelementptr inbounds [36 x i32], [36 x i32]* %graph, i64 0, i64 %idx5
  store i32 15, i32* %p5, align 4
  %idx6 = add i64 %twoN, 3
  %p6 = getelementptr inbounds [36 x i32], [36 x i32]* %graph, i64 0, i64 %idx6
  store i32 11, i32* %p6, align 4
  %idx7 = add i64 %threeN, 2
  %p7 = getelementptr inbounds [36 x i32], [36 x i32]* %graph, i64 0, i64 %idx7
  store i32 11, i32* %p7, align 4
  %idx8 = add i64 %threeN, 4
  %p8 = getelementptr inbounds [36 x i32], [36 x i32]* %graph, i64 0, i64 %idx8
  store i32 6, i32* %p8, align 4
  %fourN = shl i64 %nA, 2
  %idx9 = add i64 %fourN, 3
  %p9 = getelementptr inbounds [36 x i32], [36 x i32]* %graph, i64 0, i64 %idx9
  store i32 6, i32* %p9, align 4
  %idx10 = add i64 %fourN, 5
  %p10 = getelementptr inbounds [36 x i32], [36 x i32]* %graph, i64 0, i64 %idx10
  store i32 9, i32* %p10, align 4
  %fiveN = add i64 %fourN, %nA
  %idx11 = add i64 %fiveN, 4
  %p11 = getelementptr inbounds [36 x i32], [36 x i32]* %graph, i64 0, i64 %idx11
  store i32 9, i32* %p11, align 4

  store i64 0, i64* %var40, align 8
  %graphptr = getelementptr inbounds [36 x i32], [36 x i32]* %graph, i64 0, i64 0
  %predptr = getelementptr inbounds [6 x i32], [6 x i32]* %pred, i64 0, i64 0
  %distptr = getelementptr inbounds [6 x i32], [6 x i32]* %dist, i64 0, i64 0
  %n_for_call = load i64, i64* %var38, align 8
  %src_for_call = load i64, i64* %var40, align 8
  call void (i32*, ...) @dijkstra(i32* %graphptr, i64 %n_for_call, i64 %src_for_call, i32* %distptr, i32* %predptr)

  store i64 0, i64* %var18, align 8
  br label %print_loop

print_loop:
  %pi = load i64, i64* %var18, align 8
  %n_for_print = load i64, i64* %var38, align 8
  %cmp_print = icmp ult i64 %pi, %n_for_print
  br i1 %cmp_print, label %print_body, label %after_print

print_body:
  %d_gep = getelementptr inbounds [6 x i32], [6 x i32]* %dist, i64 0, i64 %pi
  %d_val = load i32, i32* %d_gep, align 4
  %cmp_inf = icmp sgt i32 %d_val, 1061109566
  br i1 %cmp_inf, label %print_inf, label %print_num

print_inf:
  %fmt_inf_ptr = getelementptr inbounds [24 x i8], [24 x i8]* @_Format, i64 0, i64 0
  %src0 = load i64, i64* %var40, align 8
  %dst0 = load i64, i64* %var18, align 8
  %call_inf = call i32 (i8*, ...) @printf(i8* %fmt_inf_ptr, i64 %src0, i64 %dst0)
  br label %print_next

print_num:
  %fmt_num_ptr = getelementptr inbounds [23 x i8], [23 x i8]* @aDistZuZuD, i64 0, i64 0
  %src1 = load i64, i64* %var40, align 8
  %dst1 = load i64, i64* %var18, align 8
  %val1 = load i32, i32* %d_gep, align 4
  %call_num = call i32 (i8*, ...) @printf(i8* %fmt_num_ptr, i64 %src1, i64 %dst1, i32 %val1)
  br label %print_next

print_next:
  %pi_old = load i64, i64* %var18, align 8
  %pi_inc = add i64 %pi_old, 1
  store i64 %pi_inc, i64* %var18, align 8
  br label %print_loop

after_print:
  store i64 5, i64* %var48, align 8
  %dstidx = load i64, i64* %var48, align 8
  %d_gep2 = getelementptr inbounds [6 x i32], [6 x i32]* %dist, i64 0, i64 %dstidx
  %d_val2 = load i32, i32* %d_gep2, align 4
  %cmp_inf2 = icmp sgt i32 %d_val2, 1061109566
  br i1 %cmp_inf2, label %no_path, label %has_path

no_path:
  %fmt_np_ptr = getelementptr inbounds [25 x i8], [25 x i8]* @aNoPathFromZuTo, i64 0, i64 0
  %src_np = load i64, i64* %var40, align 8
  %dst_np = load i64, i64* %var48, align 8
  %call_np = call i32 (i8*, ...) @printf(i8* %fmt_np_ptr, i64 %src_np, i64 %dst_np)
  br label %ret_block

has_path:
  store i64 0, i64* %var20, align 8
  %dst_i32 = trunc i64 %dstidx to i32
  store i32 %dst_i32, i32* %var24, align 4
  br label %backtrack_cond

backtrack_cond:
  %curv = load i32, i32* %var24, align 4
  %cmp_bt = icmp ne i32 %curv, -1
  br i1 %cmp_bt, label %backtrack_body, label %after_backtrack

backtrack_body:
  %len0 = load i64, i64* %var20, align 8
  %curv64 = sext i32 %curv to i64
  %path_gep = getelementptr inbounds [6 x i64], [6 x i64]* %path, i64 0, i64 %len0
  store i64 %curv64, i64* %path_gep, align 8
  %len1 = add i64 %len0, 1
  store i64 %len1, i64* %var20, align 8
  %curidx64 = sext i32 %curv to i64
  %pred_gep = getelementptr inbounds [6 x i32], [6 x i32]* %pred, i64 0, i64 %curidx64
  %nextv = load i32, i32* %pred_gep, align 4
  store i32 %nextv, i32* %var24, align 4
  br label %backtrack_cond

after_backtrack:
  %fmt_path_ptr = getelementptr inbounds [17 x i8], [17 x i8]* @aPathZuZu, i64 0, i64 0
  %src_p = load i64, i64* %var40, align 8
  %dst_p = load i64, i64* %var48, align 8
  %call_path_hdr = call i32 (i8*, ...) @printf(i8* %fmt_path_ptr, i64 %src_p, i64 %dst_p)
  store i64 0, i64* %var30, align 8
  br label %print_path_loop

print_path_loop:
  %j0 = load i64, i64* %var30, align 8
  %len2 = load i64, i64* %var20, align 8
  %cmp_j = icmp ult i64 %j0, %len2
  br i1 %cmp_j, label %print_path_body, label %after_path

print_path_body:
  %len3 = load i64, i64* %var20, align 8
  %tmp_sub1 = sub i64 %len3, %j0
  %idxp = sub i64 %tmp_sub1, 1
  %node_gep = getelementptr inbounds [6 x i64], [6 x i64]* %path, i64 0, i64 %idxp
  %node = load i64, i64* %node_gep, align 8
  store i64 %node, i64* %var50, align 8
  %j1 = load i64, i64* %var30, align 8
  %j1p = add i64 %j1, 1
  %len4 = load i64, i64* %var20, align 8
  %cmp_last = icmp uge i64 %j1p, %len4
  br i1 %cmp_last, label %choose_empty, label %choose_arrow

choose_arrow:
  %arrow_ptr = getelementptr inbounds [4 x i8], [4 x i8]* @asc_140004059, i64 0, i64 0
  br label %suffix_ready

choose_empty:
  %empty_ptr = getelementptr inbounds [1 x i8], [1 x i8]* @unk_14000405D, i64 0, i64 0
  br label %suffix_ready

suffix_ready:
  %suffix = phi i8* [ %arrow_ptr, %choose_arrow ], [ %empty_ptr, %choose_empty ]
  %fmt_node_ptr = getelementptr inbounds [7 x i8], [7 x i8]* @aZuS, i64 0, i64 0
  %node_val = load i64, i64* %var50, align 8
  %call_node = call i32 (i8*, ...) @printf(i8* %fmt_node_ptr, i64 %node_val, i8* %suffix)
  %j2 = load i64, i64* %var30, align 8
  %j2_inc = add i64 %j2, 1
  store i64 %j2_inc, i64* %var30, align 8
  br label %print_path_loop

after_path:
  %putc = call i32 @putchar(i32 10)
  br label %ret_block

ret_block:
  ret i32 0
}