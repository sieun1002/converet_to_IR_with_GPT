; ModuleID = 'main_from_asm'
target triple = "x86_64-pc-windows-msvc"

@_Format = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@asc_140004015 = private unnamed_addr constant [2 x i8] c" \00", align 1
@unk_140004017 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@aZuS = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@aDistZuZuD = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @putchar(i32)
declare dso_local void @bfs(i32*, i64, i64, i32*, i64*, i64*)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define dso_local i32 @main() {
entry:
  %var_28 = alloca i64, align 8
  %var_30 = alloca i64, align 8
  %var_20 = alloca i64, align 8
  %var_18 = alloca i64, align 8
  %var_168 = alloca i64, align 8
  %arr_adj = alloca [48 x i32], align 16
  %arr_dist = alloca [8 x i32], align 16
  %arr_order = alloca [7 x i64], align 16

  store i64 7, i64* %var_28, align 8

  %adj_i8 = bitcast [48 x i32]* %arr_adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj_i8, i8 0, i64 192, i1 false)

  %adj0 = getelementptr inbounds [48 x i32], [48 x i32]* %arr_adj, i64 0, i64 0
  store i32 0, i32* %adj0, align 4
  %adj1 = getelementptr inbounds [48 x i32], [48 x i32]* %arr_adj, i64 0, i64 1
  store i32 1, i32* %adj1, align 4

  %N = load i64, i64* %var_28, align 8
  %adjN = getelementptr inbounds [48 x i32], [48 x i32]* %arr_adj, i64 0, i64 %N
  store i32 1, i32* %adjN, align 4

  %adj2 = getelementptr inbounds [48 x i32], [48 x i32]* %arr_adj, i64 0, i64 2
  store i32 1, i32* %adj2, align 4

  %N_x2 = shl i64 %N, 1
  %adjN2 = getelementptr inbounds [48 x i32], [48 x i32]* %arr_adj, i64 0, i64 %N_x2
  store i32 1, i32* %adjN2, align 4

  %N_plus3 = add i64 %N, 3
  %adjNplus3 = getelementptr inbounds [48 x i32], [48 x i32]* %arr_adj, i64 0, i64 %N_plus3
  store i32 1, i32* %adjNplus3, align 4

  %N3 = add i64 %N_x2, %N
  %N3_plus1 = add i64 %N3, 1
  %adjN3p1 = getelementptr inbounds [48 x i32], [48 x i32]* %arr_adj, i64 0, i64 %N3_plus1
  store i32 1, i32* %adjN3p1, align 4

  %N_plus4 = add i64 %N, 4
  %adjNplus4 = getelementptr inbounds [48 x i32], [48 x i32]* %arr_adj, i64 0, i64 %N_plus4
  store i32 1, i32* %adjNplus4, align 4

  %N_x4 = shl i64 %N, 2
  %N_x4_plus1 = add i64 %N_x4, 1
  %adjN4p1 = getelementptr inbounds [48 x i32], [48 x i32]* %arr_adj, i64 0, i64 %N_x4_plus1
  store i32 1, i32* %adjN4p1, align 4

  %N2_plus5 = add i64 %N_x2, 5
  %adjN2p5 = getelementptr inbounds [48 x i32], [48 x i32]* %arr_adj, i64 0, i64 %N2_plus5
  store i32 1, i32* %adjN2p5, align 4

  %N5 = add i64 %N_x4, %N
  %N5_plus2 = add i64 %N5, 2
  %adjN5p2 = getelementptr inbounds [48 x i32], [48 x i32]* %arr_adj, i64 0, i64 %N5_plus2
  store i32 1, i32* %adjN5p2, align 4

  %N4_plus5 = add i64 %N_x4, 5
  %adjN4p5 = getelementptr inbounds [48 x i32], [48 x i32]* %arr_adj, i64 0, i64 %N4_plus5
  store i32 1, i32* %adjN4p5, align 4

  %N5_plus4 = add i64 %N5, 4
  %adjN5p4 = getelementptr inbounds [48 x i32], [48 x i32]* %arr_adj, i64 0, i64 %N5_plus4
  store i32 1, i32* %adjN5p4, align 4

  %N5_plus6 = add i64 %N5, 6
  %adjN5p6 = getelementptr inbounds [48 x i32], [48 x i32]* %arr_adj, i64 0, i64 %N5_plus6
  store i32 1, i32* %adjN5p6, align 4

  %N6 = shl i64 %N3, 1
  %N6_plus5 = add i64 %N6, 5
  %adjN6p5 = getelementptr inbounds [48 x i32], [48 x i32]* %arr_adj, i64 0, i64 %N6_plus5
  store i32 1, i32* %adjN6p5, align 4

  store i64 0, i64* %var_30, align 8
  store i64 0, i64* %var_168, align 8

  %adj_base = getelementptr inbounds [48 x i32], [48 x i32]* %arr_adj, i64 0, i64 0
  %dist_base = getelementptr inbounds [8 x i32], [8 x i32]* %arr_dist, i64 0, i64 0
  %order_base = getelementptr inbounds [7 x i64], [7 x i64]* %arr_order, i64 0, i64 0
  %src0 = load i64, i64* %var_30, align 8
  call void @bfs(i32* %adj_base, i64 %N, i64 %src0, i32* %dist_base, i64* %order_base, i64* %var_168)

  %fmt_hdr_ptr = getelementptr inbounds [21 x i8], [21 x i8]* @_Format, i64 0, i64 0
  %src_print = load i64, i64* %var_30, align 8
  %call_printf_hdr = call i32 (i8*, ...) @printf(i8* %fmt_hdr_ptr, i64 %src_print)

  store i64 0, i64* %var_18, align 8
  br label %loop_cond

loop_cond:                                             ; preds = %loop_body, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop_body ]
  %len = load i64, i64* %var_168, align 8
  %cmp_i_len = icmp ult i64 %i, %len
  br i1 %cmp_i_len, label %loop_body, label %loop_end

loop_body:                                             ; preds = %loop_cond
  %i_plus1 = add i64 %i, 1
  %cmp_sep = icmp ult i64 %i_plus1, %len
  %space_ptr = getelementptr inbounds [2 x i8], [2 x i8]* @asc_140004015, i64 0, i64 0
  %empty_ptr = getelementptr inbounds [1 x i8], [1 x i8]* @unk_140004017, i64 0, i64 0
  %sep_ptr = select i1 %cmp_sep, i8* %space_ptr, i8* %empty_ptr

  %ord_elem_ptr = getelementptr inbounds [7 x i64], [7 x i64]* %arr_order, i64 0, i64 %i
  %ord_elem = load i64, i64* %ord_elem_ptr, align 8

  %fmt_elem_ptr = getelementptr inbounds [6 x i8], [6 x i8]* @aZuS, i64 0, i64 0
  %call_printf_elem = call i32 (i8*, ...) @printf(i8* %fmt_elem_ptr, i64 %ord_elem, i8* %sep_ptr)

  %i.next = add i64 %i, 1
  br label %loop_cond

loop_end:                                              ; preds = %loop_cond
  %nl = call i32 @putchar(i32 10)

  store i64 0, i64* %var_20, align 8
  br label %dist_cond

dist_cond:                                             ; preds = %dist_body, %loop_end
  %j = phi i64 [ 0, %loop_end ], [ %j.next, %dist_body ]
  %N_now = load i64, i64* %var_28, align 8
  %cmp_j_N = icmp ult i64 %j, %N_now
  br i1 %cmp_j_N, label %dist_body, label %dist_end

dist_body:                                             ; preds = %dist_cond
  %dist_j_ptr = getelementptr inbounds [8 x i32], [8 x i32]* %arr_dist, i64 0, i64 %j
  %dist_j = load i32, i32* %dist_j_ptr, align 4
  %src_again = load i64, i64* %var_30, align 8

  %fmt_dist_ptr = getelementptr inbounds [23 x i8], [23 x i8]* @aDistZuZuD, i64 0, i64 0
  %call_printf_dist = call i32 (i8*, ...) @printf(i8* %fmt_dist_ptr, i64 %src_again, i64 %j, i32 %dist_j)

  %j.next = add i64 %j, 1
  br label %dist_cond

dist_end:                                              ; preds = %dist_cond
  ret i32 0
}