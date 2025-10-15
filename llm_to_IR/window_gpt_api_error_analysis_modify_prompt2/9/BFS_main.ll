; ModuleID = 'bfs_main'
target triple = "x86_64-pc-windows-msvc"

@_Format = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@aZuS = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@aDistZuZuD = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1
@asc_140004015 = private unnamed_addr constant [2 x i8] c" \00", align 1
@unk_140004017 = private unnamed_addr constant [1 x i8] c"\00", align 1

declare dso_local i32 @printf(i8* noundef, ...)
declare dso_local i32 @putchar(i32 noundef)
declare dso_local void @bfs(i8* noundef, i64 noundef, i64 noundef, i8* noundef, i8* noundef, i8* noundef)
declare i8* @llvm.frameaddress.p0i8(i32)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define dso_local i32 @main(i32 %argc, i8** %argv) {
entry:
  %var_28 = alloca i64, align 8
  %var_30 = alloca i64, align 8
  %var_20 = alloca i64, align 8
  %var_18 = alloca i64, align 8
  %var_168 = alloca i64, align 8
  %var_100 = alloca [48 x i32], align 16
  %var_160 = alloca [64 x i64], align 16
  %var_120 = alloca [64 x i32], align 16

  store i64 7, i64* %var_28, align 8

  %var_100.i8 = bitcast [48 x i32]* %var_100 to i8*
  call void @llvm.memset.p0i8.i64(i8* %var_100.i8, i8 0, i64 192, i1 false)

  %base0 = getelementptr inbounds [48 x i32], [48 x i32]* %var_100, i64 0, i64 0
  store i32 0, i32* %base0, align 4

  %idx1 = getelementptr inbounds [48 x i32], [48 x i32]* %var_100, i64 0, i64 1
  store i32 1, i32* %idx1, align 4

  %idx2 = getelementptr inbounds [48 x i32], [48 x i32]* %var_100, i64 0, i64 2
  store i32 1, i32* %idx2, align 4

  %n0 = load i64, i64* %var_28, align 8
  %p_n = getelementptr inbounds [48 x i32], [48 x i32]* %var_100, i64 0, i64 %n0
  store i32 1, i32* %p_n, align 4

  %n1 = load i64, i64* %var_28, align 8
  %twon = add i64 %n1, %n1
  %p_2n = getelementptr inbounds [48 x i32], [48 x i32]* %var_100, i64 0, i64 %twon
  store i32 1, i32* %p_2n, align 4

  %n2 = load i64, i64* %var_28, align 8
  %n2p3 = add i64 %n2, 3
  %p_n2p3 = getelementptr inbounds [48 x i32], [48 x i32]* %var_100, i64 0, i64 %n2p3
  store i32 1, i32* %p_n2p3, align 4

  %n3 = load i64, i64* %var_28, align 8
  %t1 = add i64 %n3, %n3
  %t2 = add i64 %t1, %n3
  %t3 = add i64 %t2, 1
  %p_3n1 = getelementptr inbounds [48 x i32], [48 x i32]* %var_100, i64 0, i64 %t3
  store i32 1, i32* %p_3n1, align 4

  %n4 = load i64, i64* %var_28, align 8
  %n4p4 = add i64 %n4, 4
  %p_n4p4 = getelementptr inbounds [48 x i32], [48 x i32]* %var_100, i64 0, i64 %n4p4
  store i32 1, i32* %p_n4p4, align 4

  %n5 = load i64, i64* %var_28, align 8
  %fourn = shl i64 %n5, 2
  %fourn1 = add i64 %fourn, 1
  %p_4n1 = getelementptr inbounds [48 x i32], [48 x i32]* %var_100, i64 0, i64 %fourn1
  store i32 1, i32* %p_4n1, align 4

  %n6 = load i64, i64* %var_28, align 8
  %two_n = add i64 %n6, %n6
  %two_n5 = add i64 %two_n, 5
  %p_2n5 = getelementptr inbounds [48 x i32], [48 x i32]* %var_100, i64 0, i64 %two_n5
  store i32 1, i32* %p_2n5, align 4

  %n7 = load i64, i64* %var_28, align 8
  %fourn_b = shl i64 %n7, 2
  %fiven = add i64 %fourn_b, %n7
  %fiven2 = add i64 %fiven, 2
  %p_5n2 = getelementptr inbounds [48 x i32], [48 x i32]* %var_100, i64 0, i64 %fiven2
  store i32 1, i32* %p_5n2, align 4

  %n8 = load i64, i64* %var_28, align 8
  %fourn_c = shl i64 %n8, 2
  %fourn5 = add i64 %fourn_c, 5
  %p_4n5 = getelementptr inbounds [48 x i32], [48 x i32]* %var_100, i64 0, i64 %fourn5
  store i32 1, i32* %p_4n5, align 4

  %n9 = load i64, i64* %var_28, align 8
  %fourn_d = shl i64 %n9, 2
  %five_n4 = add i64 %fourn_d, %n9
  %five_n4p = add i64 %five_n4, 4
  %p_5n4 = getelementptr inbounds [48 x i32], [48 x i32]* %var_100, i64 0, i64 %five_n4p
  store i32 1, i32* %p_5n4, align 4

  %n10 = load i64, i64* %var_28, align 8
  %fourn_e = shl i64 %n10, 2
  %five_n6 = add i64 %fourn_e, %n10
  %five_n6p = add i64 %five_n6, 6
  %p_5n6 = getelementptr inbounds [48 x i32], [48 x i32]* %var_100, i64 0, i64 %five_n6p
  store i32 1, i32* %p_5n6, align 4

  %n11 = load i64, i64* %var_28, align 8
  %t4 = add i64 %n11, %n11
  %t5 = add i64 %t4, %n11
  %t6 = add i64 %t5, %t5
  %t7 = add i64 %t6, 5
  %p_6n5 = getelementptr inbounds [48 x i32], [48 x i32]* %var_100, i64 0, i64 %t7
  store i32 1, i32* %p_6n5, align 4

  store i64 0, i64* %var_30, align 8
  store i64 0, i64* %var_168, align 8

  %graph_ptr0 = getelementptr inbounds [48 x i32], [48 x i32]* %var_100, i64 0, i64 0
  %graph_i8 = bitcast i32* %graph_ptr0 to i8*
  %ncall = load i64, i64* %var_28, align 8
  %start0 = load i64, i64* %var_30, align 8
  %frameptr = call i8* @llvm.frameaddress.p0i8(i32 0)
  %order_i8 = bitcast [64 x i64]* %var_160 to i8*
  %count_i8 = bitcast i64* %var_168 to i8*
  call void @bfs(i8* %graph_i8, i64 %ncall, i64 %start0, i8* %frameptr, i8* %order_i8, i8* %count_i8)

  %start_print = load i64, i64* %var_30, align 8
  %fmt0 = getelementptr inbounds [21 x i8], [21 x i8]* @_Format, i64 0, i64 0
  %fmt0p = bitcast i8* %fmt0 to i8*
  %call_printf0 = call i32 (i8*, ...) @printf(i8* %fmt0p, i64 %start_print)

  store i64 0, i64* %var_18, align 8
  br label %loop_bfs_cond

loop_bfs_cond:
  %i0 = load i64, i64* %var_18, align 8
  %cnt0 = load i64, i64* %var_168, align 8
  %cmp0 = icmp ult i64 %i0, %cnt0
  br i1 %cmp0, label %loop_bfs_body, label %after_bfs_loop

loop_bfs_body:
  %ip1 = add i64 %i0, 1
  %cnt1 = load i64, i64* %var_168, align 8
  %space_needed = icmp ult i64 %ip1, %cnt1
  %space_ptr = getelementptr inbounds [2 x i8], [2 x i8]* @asc_140004015, i64 0, i64 0
  %empty_ptr = getelementptr inbounds [1 x i8], [1 x i8]* @unk_140004017, i64 0, i64 0
  %delim_sel = select i1 %space_needed, i8* %space_ptr, i8* %empty_ptr

  %order_elem_ptr = getelementptr inbounds [64 x i64], [64 x i64]* %var_160, i64 0, i64 %i0
  %order_val = load i64, i64* %order_elem_ptr, align 8

  %fmt1 = getelementptr inbounds [6 x i8], [6 x i8]* @aZuS, i64 0, i64 0
  %fmt1p = bitcast i8* %fmt1 to i8*
  %call_printf1 = call i32 (i8*, ...) @printf(i8* %fmt1p, i64 %order_val, i8* %delim_sel)

  %inc_i = add i64 %i0, 1
  store i64 %inc_i, i64* %var_18, align 8
  br label %loop_bfs_cond

after_bfs_loop:
  %nl = call i32 @putchar(i32 10)

  store i64 0, i64* %var_20, align 8
  br label %loop_dist_cond

loop_dist_cond:
  %j0 = load i64, i64* %var_20, align 8
  %nlimit = load i64, i64* %var_28, align 8
  %cmpj = icmp ult i64 %j0, %nlimit
  br i1 %cmpj, label %loop_dist_body, label %ret

loop_dist_body:
  %dist_ptr = getelementptr inbounds [64 x i32], [64 x i32]* %var_120, i64 0, i64 %j0
  %dist_val = load i32, i32* %dist_ptr, align 4

  %src_val = load i64, i64* %var_30, align 8

  %fmt2 = getelementptr inbounds [23 x i8], [23 x i8]* @aDistZuZuD, i64 0, i64 0
  %fmt2p = bitcast i8* %fmt2 to i8*
  %call_printf2 = call i32 (i8*, ...) @printf(i8* %fmt2p, i64 %src_val, i64 %j0, i32 %dist_val)

  %inc_j = add i64 %j0, 1
  store i64 %inc_j, i64* %var_20, align 8
  br label %loop_dist_cond

ret:
  ret i32 0
}