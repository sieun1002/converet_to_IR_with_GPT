; ModuleID = 'main.ll'
source_filename = "main.c"
target triple = "x86_64-pc-linux-gnu"

@.str.header = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str.item   = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.space  = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty  = private unnamed_addr constant [1 x i8] zeroinitializer, align 1

declare void @dfs(i32* noundef, i64 noundef, i64 noundef, i64* noundef, i64* noundef)
declare i32 @printf(i8* noundef, ...)
declare i32 @putchar(i32 noundef)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define i32 @main() local_unnamed_addr {
entry:
  ; locals
  %adj      = alloca [49 x i32], align 16
  %out      = alloca [8 x i64],  align 16
  %n        = alloca i64,        align 8
  %start    = alloca i64,        align 8
  %outLen   = alloca i64,        align 8
  %i        = alloca i64,        align 8

  ; n = 7, start = 0, outLen = 0
  store i64 7, i64* %n, align 8
  store i64 0, i64* %start, align 8
  store i64 0, i64* %outLen, align 8

  ; memset(adj, 0, 49*4)
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 196, i1 false)

  ; Build undirected adjacency matrix for n = 7
  ; Fixed entries at indices 1 and 2
  %adj.idx1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %adj.idx1, align 4
  %adj.idx2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %adj.idx2, align 4

  %nval = load i64, i64* %n, align 8

  ; adj[n] = 1
  %idx_n = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %nval
  store i32 1, i32* %idx_n, align 4

  ; adj[2n] = 1
  %mul2n = shl i64 %nval, 1
  %idx_2n = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %mul2n
  store i32 1, i32* %idx_2n, align 4

  ; adj[n+3] = 1
  %n_plus_3 = add i64 %nval, 3
  %idx_n_plus_3 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %n_plus_3
  store i32 1, i32* %idx_n_plus_3, align 4

  ; adj[3n+1] = 1
  %mul3n = add i64 %mul2n, %nval
  %mul3n_plus_1 = add i64 %mul3n, 1
  %idx_3n_plus_1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %mul3n_plus_1
  store i32 1, i32* %idx_3n_plus_1, align 4

  ; adj[n+4] = 1
  %n_plus_4 = add i64 %nval, 4
  %idx_n_plus_4 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %n_plus_4
  store i32 1, i32* %idx_n_plus_4, align 4

  ; adj[4n+1] = 1
  %mul4n = shl i64 %nval, 2
  %mul4n_plus_1 = add i64 %mul4n, 1
  %idx_4n_plus_1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %mul4n_plus_1
  store i32 1, i32* %idx_4n_plus_1, align 4

  ; adj[2n+5] = 1
  %mul2n_plus_5 = add i64 %mul2n, 5
  %idx_2n_plus_5 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %mul2n_plus_5
  store i32 1, i32* %idx_2n_plus_5, align 4

  ; adj[5n+2] = 1
  %mul5n = add i64 %mul4n, %nval
  %mul5n_plus_2 = add i64 %mul5n, 2
  %idx_5n_plus_2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %mul5n_plus_2
  store i32 1, i32* %idx_5n_plus_2, align 4

  ; adj[4n+5] = 1
  %mul4n_plus_5 = add i64 %mul4n, 5
  %idx_4n_plus_5 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %mul4n_plus_5
  store i32 1, i32* %idx_4n_plus_5, align 4

  ; adj[5n+4] = 1
  %mul5n_plus_4 = add i64 %mul5n, 4
  %idx_5n_plus_4 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %mul5n_plus_4
  store i32 1, i32* %idx_5n_plus_4, align 4

  ; adj[5n+6] = 1
  %mul5n_plus_6 = add i64 %mul5n, 6
  %idx_5n_plus_6 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %mul5n_plus_6
  store i32 1, i32* %idx_5n_plus_6, align 4

  ; adj[6n+5] = 1
  %mul6n = shl i64 %mul3n, 1
  %mul6n_plus_5 = add i64 %mul6n, 5
  %idx_6n_plus_5 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %mul6n_plus_5
  store i32 1, i32* %idx_6n_plus_5, align 4

  ; call dfs(adj, n, start, out, &outLen)
  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %out.base = getelementptr inbounds [8 x i64],  [8 x i64]*  %out, i64 0, i64 0
  %start.val = load i64, i64* %start, align 8
  call void @dfs(i32* %adj.base, i64 %nval, i64 %start.val, i64* %out.base, i64* %outLen)

  ; printf("DFS preorder from %zu: ", start)
  %fmt.header.ptr = getelementptr inbounds [24 x i8], [24 x i8]* @.str.header, i64 0, i64 0
  %call.header = call i32 (i8*, ...) @printf(i8* %fmt.header.ptr, i64 %start.val)

  ; i = 0
  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:
  %i.cur = load i64, i64* %i, align 8
  %len.cur = load i64, i64* %outLen, align 8
  %cmp = icmp ult i64 %i.cur, %len.cur
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:
  ; choose separator: " " if (i+1) < len else ""
  %i.plus1 = add i64 %i.cur, 1
  %need.space = icmp ult i64 %i.plus1, %len.cur
  %sep.space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  %sep.empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  %sep.ptr = select i1 %need.space, i8* %sep.space.ptr, i8* %sep.empty.ptr

  ; val = out[i]
  %out.elem.ptr = getelementptr inbounds [8 x i64], [8 x i64]* %out, i64 0, i64 %i.cur
  %val.cur = load i64, i64* %out.elem.ptr, align 8

  ; printf("%zu%s", val, sep)
  %fmt.item.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str.item, i64 0, i64 0
  %call.item = call i32 (i8*, ...) @printf(i8* %fmt.item.ptr, i64 %val.cur, i8* %sep.ptr)

  ; i++
  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop.cond

loop.end:
  ; putchar('\n')
  %call.nl = call i32 @putchar(i32 10)
  ret i32 0
}