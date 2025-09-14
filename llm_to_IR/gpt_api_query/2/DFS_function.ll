; ModuleID = 'recovered_main.ll'
target triple = "x86_64-unknown-linux-gnu"

@.str.header = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str.elem    = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.space   = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty   = private unnamed_addr constant [1 x i8] c"\00", align 1

declare void @dfs(i32* %adj, i64 %n, i64 %start, i64* %out, i64* %out_len)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

declare void @llvm.memset.p0.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define i32 @main() {
entry:
  %adj = alloca [49 x i32], align 16
  %order = alloca [8 x i64], align 16
  %out_len = alloca i64, align 8
  %n = alloca i64, align 8
  %start = alloca i64, align 8
  %i = alloca i64, align 8

  ; n = 7, start = 0, out_len = 0
  store i64 7, i64* %n, align 8
  store i64 0, i64* %start, align 8
  store i64 0, i64* %out_len, align 8

  ; memset(adj, 0, 49 * sizeof(i32))
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0.i64(i8* %adj.i8, i8 0, i64 196, i1 false)

  ; Set adjacency matrix entries to 1 at indices:
  ; 1, 2, 7, 10, 11, 14, 19, 22, 29, 33, 37, 39, 41, 47
  %adj.p0 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %adj.p0, align 4
  %adj.p1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %adj.p1, align 4
  %adj.p2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 7
  store i32 1, i32* %adj.p2, align 4
  %adj.p3 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 10
  store i32 1, i32* %adj.p3, align 4
  %adj.p4 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 11
  store i32 1, i32* %adj.p4, align 4
  %adj.p5 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 14
  store i32 1, i32* %adj.p5, align 4
  %adj.p6 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 19
  store i32 1, i32* %adj.p6, align 4
  %adj.p7 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 22
  store i32 1, i32* %adj.p7, align 4
  %adj.p8 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 29
  store i32 1, i32* %adj.p8, align 4
  %adj.p9 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 33
  store i32 1, i32* %adj.p9, align 4
  %adj.p10 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 37
  store i32 1, i32* %adj.p10, align 4
  %adj.p11 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 39
  store i32 1, i32* %adj.p11, align 4
  %adj.p12 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 41
  store i32 1, i32* %adj.p12, align 4
  %adj.p13 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 47
  store i32 1, i32* %adj.p13, align 4

  ; dfs(adj, n, start, order, &out_len)
  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %order.base = getelementptr inbounds [8 x i64], [8 x i64]* %order, i64 0, i64 0
  %n.val = load i64, i64* %n, align 8
  %start.val = load i64, i64* %start, align 8
  call void @dfs(i32* %adj.base, i64 %n.val, i64 %start.val, i64* %order.base, i64* %out_len)

  ; printf("DFS preorder from %zu: ", start)
  %fmt.header = getelementptr inbounds [24 x i8], [24 x i8]* @.str.header, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt.header, i64 %start.val)

  ; i = 0
  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %i.cur = load i64, i64* %i, align 8
  %len.cur = load i64, i64* %out_len, align 8
  %cond = icmp ult i64 %i.cur, %len.cur
  br i1 %cond, label %body, label %done

body:
  %next = add i64 %i.cur, 1
  %is_last = icmp uge i64 %next, %len.cur
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  %delim.sel = select i1 %is_last, i8* %empty.ptr, i8* %space.ptr

  %elem.ptr = getelementptr inbounds [8 x i64], [8 x i64]* %order, i64 0, i64 %i.cur
  %elem = load i64, i64* %elem.ptr, align 8
  %fmt.elem = getelementptr inbounds [6 x i8], [6 x i8]* @.str.elem, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt.elem, i64 %elem, i8* %delim.sel)

  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop

done:
  call i32 @putchar(i32 10)
  ret i32 0
}