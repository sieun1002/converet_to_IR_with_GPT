; ModuleID = 'main.ll'
source_filename = "main.c"
target triple = "x86_64-unknown-linux-gnu"

@.str.pre = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str.elem = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] c"\00", align 1

declare void @dfs(i32* noundef, i64 noundef, i64 noundef, i64* noundef, i64* noundef)
declare i32 @printf(i8* noundef, ...)
declare i32 @putchar(i32 noundef)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define i32 @main() {
entry:
  ; locals
  %adj = alloca [49 x i32], align 16
  %out = alloca [8 x i64], align 16
  %n = alloca i64, align 8
  %start = alloca i64, align 8
  %len = alloca i64, align 8
  %i = alloca i64, align 8

  ; n = 7, start = 0
  store i64 7, i64* %n, align 8
  store i64 0, i64* %start, align 8
  store i64 0, i64* %len, align 8

  ; zero adj (49 * 4 = 196 bytes)
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 196, i1 false)

  ; set edges (undirected) as in the binary
  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %p1  = getelementptr inbounds i32, i32* %adj.base, i64 1
  store i32 1, i32* %p1, align 4
  %p2  = getelementptr inbounds i32, i32* %adj.base, i64 2
  store i32 1, i32* %p2, align 4
  %p7  = getelementptr inbounds i32, i32* %adj.base, i64 7
  store i32 1, i32* %p7, align 4
  %p10 = getelementptr inbounds i32, i32* %adj.base, i64 10
  store i32 1, i32* %p10, align 4
  %p11 = getelementptr inbounds i32, i32* %adj.base, i64 11
  store i32 1, i32* %p11, align 4
  %p14 = getelementptr inbounds i32, i32* %adj.base, i64 14
  store i32 1, i32* %p14, align 4
  %p19 = getelementptr inbounds i32, i32* %adj.base, i64 19
  store i32 1, i32* %p19, align 4
  %p22 = getelementptr inbounds i32, i32* %adj.base, i64 22
  store i32 1, i32* %p22, align 4
  %p29 = getelementptr inbounds i32, i32* %adj.base, i64 29
  store i32 1, i32* %p29, align 4
  %p33 = getelementptr inbounds i32, i32* %adj.base, i64 33
  store i32 1, i32* %p33, align 4
  %p37 = getelementptr inbounds i32, i32* %adj.base, i64 37
  store i32 1, i32* %p37, align 4
  %p39 = getelementptr inbounds i32, i32* %adj.base, i64 39
  store i32 1, i32* %p39, align 4
  %p41 = getelementptr inbounds i32, i32* %adj.base, i64 41
  store i32 1, i32* %p41, align 4
  %p47 = getelementptr inbounds i32, i32* %adj.base, i64 47
  store i32 1, i32* %p47, align 4

  ; call dfs(adj, n, start, out, &len)
  %out.base = getelementptr inbounds [8 x i64], [8 x i64]* %out, i64 0, i64 0
  %n.val = load i64, i64* %n, align 8
  %start.val = load i64, i64* %start, align 8
  call void @dfs(i32* %adj.base, i64 %n.val, i64 %start.val, i64* %out.base, i64* %len)

  ; print header: "DFS preorder from %zu: "
  %fmt.pre = getelementptr inbounds [24 x i8], [24 x i8]* @.str.pre, i64 0, i64 0
  %start.print = load i64, i64* %start, align 8
  %call.pre = call i32 (i8*, ...) @printf(i8* %fmt.pre, i64 %start.print)

  ; i = 0
  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:
  %i.cur = load i64, i64* %i, align 8
  %len.cur = load i64, i64* %len, align 8
  %cmp = icmp ult i64 %i.cur, %len.cur
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:
  ; choose suffix: space if (i+1) < len else empty
  %i.next = add i64 %i.cur, 1
  %need.space = icmp ult i64 %i.next, %len.cur
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  %suffix = select i1 %need.space, i8* %space.ptr, i8* %empty.ptr

  ; load out[i]
  %elem.ptr = getelementptr inbounds [8 x i64], [8 x i64]* %out, i64 0, i64 %i.cur
  %elem = load i64, i64* %elem.ptr, align 8

  ; printf("%zu%s", elem, suffix)
  %fmt.elem = getelementptr inbounds [6 x i8], [6 x i8]* @.str.elem, i64 0, i64 0
  %call.elem = call i32 (i8*, ...) @printf(i8* %fmt.elem, i64 %elem, i8* %suffix)

  ; i++
  store i64 %i.next, i64* %i, align 8
  br label %loop.cond

loop.end:
  ; newline
  %newline = call i32 @putchar(i32 10)
  ret i32 0
}