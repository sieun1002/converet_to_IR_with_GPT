; ModuleID = 'main.ll'

declare void @bfs(i32* noundef, i64 noundef, i64 noundef, i32* noundef, i64* noundef, i64* noundef)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1)

@.str_bfs   = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str_item  = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str_dist  = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

define dso_local i32 @main() {
entry:
  ; locals
  %adj      = alloca [49 x i32], align 16
  %dist     = alloca [7 x i32], align 16
  %order    = alloca [7 x i64], align 16
  %n        = alloca i64, align 8
  %src      = alloca i64, align 8
  %orderlen = alloca i64, align 8
  %i        = alloca i64, align 8
  %j        = alloca i64, align 8

  ; n = 7, src = 0, orderlen = 0
  store i64 7, i64* %n, align 8
  store i64 0, i64* %src, align 8
  store i64 0, i64* %orderlen, align 8

  ; zero adjacency matrix (49 * 4 = 196 bytes)
  %adj.base.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.base.i8, i8 0, i64 196, i1 false)

  ; compute some multiples of n
  %N       = load i64, i64* %n, align 8
  %twoN    = add i64 %N, %N
  %threeN  = add i64 %twoN, %N
  %fourN   = shl i64 %N, 2
  %fiveN   = add i64 %fourN, %N
  %sixN    = add i64 %threeN, %threeN

  ; base pointers
  %adj.ptr   = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %dist.ptr  = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %order.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0

  ; set undirected edges by setting 1s in adjacency matrix (row-major)
  ; 0-1 and 1-0
  %p_1 = getelementptr inbounds i32, i32* %adj.ptr, i64 1
  store i32 1, i32* %p_1, align 4
  %p_N = getelementptr inbounds i32, i32* %adj.ptr, i64 %N
  store i32 1, i32* %p_N, align 4

  ; 0-2 and 2-0
  %p_2 = getelementptr inbounds i32, i32* %adj.ptr, i64 2
  store i32 1, i32* %p_2, align 4
  %p_2N = getelementptr inbounds i32, i32* %adj.ptr, i64 %twoN
  store i32 1, i32* %p_2N, align 4

  ; 1-3 and 3-1
  %N_plus_3 = add i64 %N, 3
  %p_Np3 = getelementptr inbounds i32, i32* %adj.ptr, i64 %N_plus_3
  store i32 1, i32* %p_Np3, align 4
  %threeN_plus_1 = add i64 %threeN, 1
  %p_3Np1 = getelementptr inbounds i32, i32* %adj.ptr, i64 %threeN_plus_1
  store i32 1, i32* %p_3Np1, align 4

  ; 1-4 and 4-1
  %N_plus_4 = add i64 %N, 4
  %p_Np4 = getelementptr inbounds i32, i32* %adj.ptr, i64 %N_plus_4
  store i32 1, i32* %p_Np4, align 4
  %fourN_plus_1 = add i64 %fourN, 1
  %p_4Np1 = getelementptr inbounds i32, i32* %adj.ptr, i64 %fourN_plus_1
  store i32 1, i32* %p_4Np1, align 4

  ; 2-5 and 5-2
  %twoN_plus_5 = add i64 %twoN, 5
  %p_2Np5 = getelementptr inbounds i32, i32* %adj.ptr, i64 %twoN_plus_5
  store i32 1, i32* %p_2Np5, align 4
  %fiveN_plus_2 = add i64 %fiveN, 2
  %p_5Np2 = getelementptr inbounds i32, i32* %adj.ptr, i64 %fiveN_plus_2
  store i32 1, i32* %p_5Np2, align 4

  ; 4-5 and 5-4
  %fourN_plus_5 = add i64 %fourN, 5
  %p_4Np5 = getelementptr inbounds i32, i32* %adj.ptr, i64 %fourN_plus_5
  store i32 1, i32* %p_4Np5, align 4
  %fiveN_plus_4 = add i64 %fiveN, 4
  %p_5Np4 = getelementptr inbounds i32, i32* %adj.ptr, i64 %fiveN_plus_4
  store i32 1, i32* %p_5Np4, align 4

  ; 5-6 and 6-5
  %fiveN_plus_6 = add i64 %fiveN, 6
  %p_5Np6 = getelementptr inbounds i32, i32* %adj.ptr, i64 %fiveN_plus_6
  store i32 1, i32* %p_5Np6, align 4
  %sixN_plus_5 = add i64 %sixN, 5
  %p_6Np5 = getelementptr inbounds i32, i32* %adj.ptr, i64 %sixN_plus_5
  store i32 1, i32* %p_6Np5, align 4

  ; call bfs(adj, n, src, dist, order, &orderlen)
  %src.val = load i64, i64* %src, align 8
  call void @bfs(i32* %adj.ptr, i64 %N, i64 %src.val, i32* %dist.ptr, i64* %order.ptr, i64* %orderlen)

  ; printf("BFS order from %zu: ", src)
  %fmt_bfs = getelementptr inbounds [21 x i8], [21 x i8]* @.str_bfs, i64 0, i64 0
  %src.val2 = load i64, i64* %src, align 8
  %fmt_bfs_i8 = bitcast i8* %fmt_bfs to i8*
  %call_printf0 = call i32 (i8*, ...) @printf(i8* %fmt_bfs_i8, i64 %src.val2)

  ; for (i = 0; i < orderlen; ++i) printf("%zu%s", order[i], (i+1 < orderlen) ? " " : "");
  store i64 0, i64* %i, align 8
  br label %loop_bfs

loop_bfs:
  %i.cur = load i64, i64* %i, align 8
  %len.cur = load i64, i64* %orderlen, align 8
  %cond = icmp ult i64 %i.cur, %len.cur
  br i1 %cond, label %loop_body, label %loop_end

loop_body:
  %i.plus1 = add i64 %i.cur, 1
  %has_space = icmp ult i64 %i.plus1, %len.cur
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  %delim = select i1 %has_space, i8* %space.ptr, i8* %empty.ptr

  %ord.elem.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %i.cur
  %ord.elem = load i64, i64* %ord.elem.ptr, align 8

  %fmt_item = getelementptr inbounds [6 x i8], [6 x i8]* @.str_item, i64 0, i64 0
  %call_printf1 = call i32 (i8*, ...) @printf(i8* %fmt_item, i64 %ord.elem, i8* %delim)

  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop_bfs

loop_end:
  call i32 @putchar(i32 10)

  ; for (j = 0; j < n; ++j) printf("dist(%zu -> %zu) = %d\n", src, j, dist[j]);
  store i64 0, i64* %j, align 8
  br label %dist_loop

dist_loop:
  %j.cur = load i64, i64* %j, align 8
  %cond2 = icmp ult i64 %j.cur, %N
  br i1 %cond2, label %dist_body, label %ret

dist_body:
  %d.ptr = getelementptr inbounds i32, i32* %dist.ptr, i64 %j.cur
  %d.val = load i32, i32* %d.ptr, align 4

  %fmt_dist = getelementptr inbounds [23 x i8], [23 x i8]* @.str_dist, i64 0, i64 0
  %src.val3 = load i64, i64* %src, align 8
  %call_printf2 = call i32 (i8*, ...) @printf(i8* %fmt_dist, i64 %src.val3, i64 %j.cur, i32 %d.val)

  %j.next = add i64 %j.cur, 1
  store i64 %j.next, i64* %j, align 8
  br label %dist_loop

ret:
  ret i32 0
}