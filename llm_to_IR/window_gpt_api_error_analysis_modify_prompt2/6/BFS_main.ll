; ModuleID = 'main.ll'
target triple = "x86_64-pc-windows-msvc"

@_Format = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@asc_140004015 = private unnamed_addr constant [2 x i8] c" \00", align 1
@unk_140004017 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@aZuS = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@aDistZuZuD = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare dllimport i32 @printf(i8*, ...)
declare dllimport i32 @putchar(i32)
declare void @bfs(i32*, i64, i64, i8*, i64*, i64*)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1)

define dso_local i32 @main(i32 %argc, i8** %argv) {
entry:
  %adj = alloca [48 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %order_len = alloca i64, align 8
  %V = alloca i64, align 8
  %src = alloca i64, align 8
  %i = alloca i64, align 8
  %u = alloca i64, align 8
  store i64 7, i64* %V, align 8
  store i64 0, i64* %src, align 8
  store i64 0, i64* %order_len, align 8
  %adj_i8 = bitcast [48 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj_i8, i8 0, i64 192, i1 false)
  %adj_base = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %adj_base, align 4
  %adj_idx2 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %adj_idx2, align 4
  %v0 = load i64, i64* %V, align 8
  %idx7 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 %v0
  store i32 1, i32* %idx7, align 4
  %v2 = shl i64 %v0, 1
  %idx14 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 %v2
  store i32 1, i32* %idx14, align 4
  %v_plus3 = add i64 %v0, 3
  %idx10 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 %v_plus3
  store i32 1, i32* %idx10, align 4
  %v3 = mul i64 %v0, 3
  %v3p1 = add i64 %v3, 1
  %idx22 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 %v3p1
  store i32 1, i32* %idx22, align 4
  %v_plus4 = add i64 %v0, 4
  %idx11 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 %v_plus4
  store i32 1, i32* %idx11, align 4
  %v4 = shl i64 %v0, 2
  %v4p1 = add i64 %v4, 1
  %idx29 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 %v4p1
  store i32 1, i32* %idx29, align 4
  %v2p5 = add i64 %v2, 5
  %idx19 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 %v2p5
  store i32 1, i32* %idx19, align 4
  %v5 = add i64 %v4, %v0
  %v5p2 = add i64 %v5, 2
  %idx37 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 %v5p2
  store i32 1, i32* %idx37, align 4
  %v4p5 = add i64 %v4, 5
  %idx33 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 %v4p5
  store i32 1, i32* %idx33, align 4
  %v5p4 = add i64 %v5, 4
  %idx39 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 %v5p4
  store i32 1, i32* %idx39, align 4
  %v5p6 = add i64 %v5, 6
  %idx41 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 %v5p6
  store i32 1, i32* %idx41, align 4
  %v6 = mul i64 %v0, 6
  %v6p5 = add i64 %v6, 5
  %idx47 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 %v6p5
  store i32 1, i32* %idx47, align 4
  %adj_ptr = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 0
  %dist_ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %order_ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  %Vval = load i64, i64* %V, align 8
  %srcval = load i64, i64* %src, align 8
  %dist_as_i8 = bitcast i32* %dist_ptr to i8*
  call void @bfs(i32* %adj_ptr, i64 %Vval, i64 %srcval, i8* %dist_as_i8, i64* %order_ptr, i64* %order_len)
  %fmt1 = getelementptr inbounds [21 x i8], [21 x i8]* @_Format, i64 0, i64 0
  %srcval2 = load i64, i64* %src, align 8
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt1, i64 %srcval2)
  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %i_cur = load i64, i64* %i, align 8
  %len = load i64, i64* %order_len, align 8
  %cmp = icmp ult i64 %i_cur, %len
  br i1 %cmp, label %body, label %after_loop

body:
  %i_plus1 = add i64 %i_cur, 1
  %cond = icmp ult i64 %i_plus1, %len
  br i1 %cond, label %sep_space, label %sep_empty

sep_space:
  %space_ptr = getelementptr inbounds [2 x i8], [2 x i8]* @asc_140004015, i64 0, i64 0
  br label %sep_join

sep_empty:
  %empty_ptr = getelementptr inbounds [1 x i8], [1 x i8]* @unk_140004017, i64 0, i64 0
  br label %sep_join

sep_join:
  %sep = phi i8* [ %space_ptr, %sep_space ], [ %empty_ptr, %sep_empty ]
  %ord_elem_ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %i_cur
  %ord_val = load i64, i64* %ord_elem_ptr, align 8
  %fmt2 = getelementptr inbounds [6 x i8], [6 x i8]* @aZuS, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt2, i64 %ord_val, i8* %sep)
  %i_next = add i64 %i_cur, 1
  store i64 %i_next, i64* %i, align 8
  br label %loop

after_loop:
  %call3 = call i32 @putchar(i32 10)
  store i64 0, i64* %u, align 8
  br label %loop2

loop2:
  %u_cur = load i64, i64* %u, align 8
  %Vnow = load i64, i64* %V, align 8
  %cmp2 = icmp ult i64 %u_cur, %Vnow
  br i1 %cmp2, label %body2, label %done

body2:
  %dist_elem_ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %u_cur
  %dist_val = load i32, i32* %dist_elem_ptr, align 4
  %fmt3 = getelementptr inbounds [23 x i8], [23 x i8]* @aDistZuZuD, i64 0, i64 0
  %src_for_print = load i64, i64* %src, align 8
  %u_for_print = add i64 %u_cur, 0
  %call4 = call i32 (i8*, ...) @printf(i8* %fmt3, i64 %src_for_print, i64 %u_for_print, i32 %dist_val)
  %u_next = add i64 %u_cur, 1
  store i64 %u_next, i64* %u, align 8
  br label %loop2

done:
  ret i32 0
}