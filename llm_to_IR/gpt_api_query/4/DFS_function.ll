; ModuleID = 'main.ll'
source_filename = "main.ll"
target triple = "x86_64-pc-linux-gnu"

@.str_pre = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str_fmt = private unnamed_addr constant [5 x i8] c"%zu%s\00", align 1
@.str_sp  = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_emp = private unnamed_addr constant [1 x i8] c"\00", align 1

declare void @dfs(i32* noundef, i64 noundef, i64 noundef, i64* noundef, i64* noundef)
declare i32 @printf(i8* noundef, ...)
declare i32 @putchar(i32 noundef)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1)

define i32 @main() {
entry:
  %adj = alloca [49 x i32], align 16
  %order = alloca [49 x i64], align 16
  %n = alloca i64, align 8
  %start = alloca i64, align 8
  %len = alloca i64, align 8
  %i = alloca i64, align 8

  store i64 7, i64* %n, align 8
  store i64 0, i64* %start, align 8
  store i64 0, i64* %len, align 8

  ; memset adj[49] = 0 (49 * 4 = 196 bytes)
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 196, i1 false)

  ; adj[7] = 1
  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %p7  = getelementptr inbounds i32, i32* %adj.base, i64 7
  store i32 1, i32* %p7, align 4
  ; adj[14] = 1
  %p14 = getelementptr inbounds i32, i32* %adj.base, i64 14
  store i32 1, i32* %p14, align 4
  ; adj[10] = 1
  %p10 = getelementptr inbounds i32, i32* %adj.base, i64 10
  store i32 1, i32* %p10, align 4
  ; adj[22] = 1
  %p22 = getelementptr inbounds i32, i32* %adj.base, i64 22
  store i32 1, i32* %p22, align 4
  ; adj[11] = 1
  %p11 = getelementptr inbounds i32, i32* %adj.base, i64 11
  store i32 1, i32* %p11, align 4
  ; adj[29] = 1
  %p29 = getelementptr inbounds i32, i32* %adj.base, i64 29
  store i32 1, i32* %p29, align 4
  ; adj[19] = 1
  %p19 = getelementptr inbounds i32, i32* %adj.base, i64 19
  store i32 1, i32* %p19, align 4
  ; adj[37] = 1
  %p37 = getelementptr inbounds i32, i32* %adj.base, i64 37
  store i32 1, i32* %p37, align 4
  ; adj[33] = 1
  %p33 = getelementptr inbounds i32, i32* %adj.base, i64 33
  store i32 1, i32* %p33, align 4
  ; adj[39] = 1
  %p39 = getelementptr inbounds i32, i32* %adj.base, i64 39
  store i32 1, i32* %p39, align 4
  ; adj[41] = 1
  %p41 = getelementptr inbounds i32, i32* %adj.base, i64 41
  store i32 1, i32* %p41, align 4
  ; adj[47] = 1
  %p47 = getelementptr inbounds i32, i32* %adj.base, i64 47
  store i32 1, i32* %p47, align 4

  ; call dfs(adj, n, start, order, &len)
  %order.base = getelementptr inbounds [49 x i64], [49 x i64]* %order, i64 0, i64 0
  %n.val = load i64, i64* %n, align 8
  %start.val = load i64, i64* %start, align 8
  call void @dfs(i32* %adj.base, i64 %n.val, i64 %start.val, i64* %order.base, i64* %len)

  ; printf("DFS preorder from %zu: ", start)
  %pre.ptr = getelementptr inbounds [24 x i8], [24 x i8]* @.str_pre, i64 0, i64 0
  %start.val2 = load i64, i64* %start, align 8
  %_ = call i32 (i8*, ...) @printf(i8* %pre.ptr, i64 %start.val2)

  ; for (i = 0; i < len; ++i) printf("%zu%s", order[i], (i+1<len) ? " " : "")
  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %i.cur = load i64, i64* %i, align 8
  %len.cur = load i64, i64* %len, align 8
  %cmp = icmp ult i64 %i.cur, %len.cur
  br i1 %cmp, label %body, label %after

body:
  %next = add i64 %i.cur, 1
  %is_last = icmp uge i64 %next, %len.cur
  br i1 %is_last, label %sel_empty, label %sel_space

sel_space:
  %sp.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_sp, i64 0, i64 0
  br label %cont

sel_empty:
  %emp.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str_emp, i64 0, i64 0
  br label %cont

cont:
  %sep = phi i8* [ %sp.ptr, %sel_space ], [ %emp.ptr, %sel_empty ]
  %elem.ptr = getelementptr inbounds [49 x i64], [49 x i64]* %order, i64 0, i64 %i.cur
  %elem = load i64, i64* %elem.ptr, align 8
  %fmt.ptr = getelementptr inbounds [5 x i8], [5 x i8]* @.str_fmt, i64 0, i64 0
  %__ = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i64 %elem, i8* %sep)
  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop

after:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}