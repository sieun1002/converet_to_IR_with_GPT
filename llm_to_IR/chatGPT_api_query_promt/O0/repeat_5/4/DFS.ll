; ModuleID = 'recovered'
target triple = "x86_64-unknown-linux-gnu"

@.str_pre = private unnamed_addr constant [25 x i8] c"DFS preorder from %zu: \00", align 1
@.str_pair = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] c"\00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @dfs(i32*, i64, i64, i64*, i64*)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define i32 @main() {
entry:
  %adj = alloca [49 x i32], align 16
  %out = alloca [8 x i64], align 16
  %N = alloca i64, align 8
  %start = alloca i64, align 8
  %outlen = alloca i64, align 8
  %i = alloca i64, align 8

  store i64 7, i64* %N, align 8
  store i64 0, i64* %start, align 8
  store i64 0, i64* %outlen, align 8

  ; memset adjacency matrix (49 * 4 = 196 bytes) to 0
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 196, i1 false)

  ; build adjacency: index = dst * N + src, value = 1
  %Nval = load i64, i64* %N, align 8
  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0

  ; 0 -> 1
  %idx_0_1.m = mul i64 %Nval, 1
  %idx_0_1.ptr = getelementptr inbounds i32, i32* %adj.base, i64 %idx_0_1.m
  store i32 1, i32* %idx_0_1.ptr, align 4

  ; 0 -> 2
  %idx_0_2.m = mul i64 %Nval, 2
  %idx_0_2.ptr = getelementptr inbounds i32, i32* %adj.base, i64 %idx_0_2.m
  store i32 1, i32* %idx_0_2.ptr, align 4

  ; 1 <-> 3
  ; 1 -> 3
  %idx_1_3.m = mul i64 %Nval, 3
  %idx_1_3 = add i64 %idx_1_3.m, 1
  %idx_1_3.ptr = getelementptr inbounds i32, i32* %adj.base, i64 %idx_1_3
  store i32 1, i32* %idx_1_3.ptr, align 4
  ; 3 -> 1
  %idx_3_1.m = mul i64 %Nval, 1
  %idx_3_1 = add i64 %idx_3_1.m, 3
  %idx_3_1.ptr = getelementptr inbounds i32, i32* %adj.base, i64 %idx_3_1
  store i32 1, i32* %idx_3_1.ptr, align 4

  ; 1 <-> 4
  ; 1 -> 4
  %idx_1_4.m = mul i64 %Nval, 4
  %idx_1_4 = add i64 %idx_1_4.m, 1
  %idx_1_4.ptr = getelementptr inbounds i32, i32* %adj.base, i64 %idx_1_4
  store i32 1, i32* %idx_1_4.ptr, align 4
  ; 4 -> 1
  %idx_4_1.m = mul i64 %Nval, 1
  %idx_4_1 = add i64 %idx_4_1.m, 4
  %idx_4_1.ptr = getelementptr inbounds i32, i32* %adj.base, i64 %idx_4_1
  store i32 1, i32* %idx_4_1.ptr, align 4

  ; 2 <-> 5
  ; 2 -> 5
  %idx_2_5.m = mul i64 %Nval, 5
  %idx_2_5 = add i64 %idx_2_5.m, 2
  %idx_2_5.ptr = getelementptr inbounds i32, i32* %adj.base, i64 %idx_2_5
  store i32 1, i32* %idx_2_5.ptr, align 4
  ; 5 -> 2
  %idx_5_2.m = mul i64 %Nval, 2
  %idx_5_2 = add i64 %idx_5_2.m, 5
  %idx_5_2.ptr = getelementptr inbounds i32, i32* %adj.base, i64 %idx_5_2
  store i32 1, i32* %idx_5_2.ptr, align 4

  ; 4 <-> 5
  ; 4 -> 5
  %idx_4_5.m = mul i64 %Nval, 5
  %idx_4_5 = add i64 %idx_4_5.m, 4
  %idx_4_5.ptr = getelementptr inbounds i32, i32* %adj.base, i64 %idx_4_5
  store i32 1, i32* %idx_4_5.ptr, align 4
  ; 5 -> 4
  %idx_5_4.m = mul i64 %Nval, 4
  %idx_5_4 = add i64 %idx_5_4.m, 5
  %idx_5_4.ptr = getelementptr inbounds i32, i32* %adj.base, i64 %idx_5_4
  store i32 1, i32* %idx_5_4.ptr, align 4

  ; 5 <-> 6
  ; 5 -> 6
  %idx_5_6.m = mul i64 %Nval, 6
  %idx_5_6 = add i64 %idx_5_6.m, 5
  %idx_5_6.ptr = getelementptr inbounds i32, i32* %adj.base, i64 %idx_5_6
  store i32 1, i32* %idx_5_6.ptr, align 4
  ; 6 -> 5
  %idx_6_5.m = mul i64 %Nval, 5
  %idx_6_5 = add i64 %idx_6_5.m, 6
  %idx_6_5.ptr = getelementptr inbounds i32, i32* %adj.base, i64 %idx_6_5
  store i32 1, i32* %idx_6_5.ptr, align 4

  ; call dfs(graph, N, start, out, &outlen)
  %graph.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %out.ptr = getelementptr inbounds [8 x i64], [8 x i64]* %out, i64 0, i64 0
  %N.call = load i64, i64* %N, align 8
  %start.call = load i64, i64* %start, align 8
  call void @dfs(i32* %graph.ptr, i64 %N.call, i64 %start.call, i64* %out.ptr, i64* %outlen)

  ; printf("DFS preorder from %zu: ", start)
  %pre.ptr = getelementptr inbounds [25 x i8], [25 x i8]* @.str_pre, i64 0, i64 0
  %start.printf = load i64, i64* %start, align 8
  %call.pre = call i32 (i8*, ...) @printf(i8* %pre.ptr, i64 %start.printf)

  ; i = 0
  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %iv = load i64, i64* %i, align 8
  %len = load i64, i64* %outlen, align 8
  %cond = icmp ult i64 %iv, %len
  br i1 %cond, label %body, label %after

body:
  %next = add i64 %iv, 1
  %has_space = icmp ult i64 %next, %len
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  %sep = select i1 %has_space, i8* %space.ptr, i8* %empty.ptr

  %elem.ptr = getelementptr inbounds [8 x i64], [8 x i64]* %out, i64 0, i64 %iv
  %elem = load i64, i64* %elem.ptr, align 8
  %fmt.pair = getelementptr inbounds [6 x i8], [6 x i8]* @.str_pair, i64 0, i64 0
  %call.pair = call i32 (i8*, ...) @printf(i8* %fmt.pair, i64 %elem, i8* %sep)

  %iv.next = add i64 %iv, 1
  store i64 %iv.next, i64* %i, align 8
  br label %loop

after:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}