; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x14AE
; Intent: perform DFS preorder traversal on a 7-node graph and print it (confidence=0.73). Evidence: builds n*n int adjacency, calls dfs, then prints "DFS preorder from %zu"
; Preconditions: dfs expects an n*n int matrix (row-major), n and start in [0..n), output buffer and length pointer valid.
; Postconditions: prints DFS preorder and newline; returns 0.

@__stack_chk_guard = external global i64

@.str.pre = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str.item = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] c"\00", align 1

; Only the necessary external declarations:
declare void @dfs(i32*, i64, i64, i64*, i64*)
declare i32 @_printf(i8*, ...)
declare i32 @_putchar(i32)
declare void @___stack_chk_fail()
declare void @llvm.memset.p0i8.i64(i8*, i8, i64, i1)

define dso_local i32 @main() local_unnamed_addr {
entry:
  %canary = alloca i64, align 8
  %adj = alloca [49 x i32], align 16
  %out = alloca [64 x i64], align 16
  %n = alloca i64, align 8
  %start = alloca i64, align 8
  %out_len = alloca i64, align 8
  %i = alloca i64, align 8

  ; stack protector prologue
  %guard = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard, i64* %canary, align 8

  ; n = 7
  store i64 7, i64* %n, align 8

  ; zero adj[49]
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 196, i1 false)

  ; Set specific edges (indices are computed from n as in the disassembly)
  ; adj[1] = 1
  %adj.idx1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %adj.idx1, align 4
  ; adj[2] = 1
  %adj.idx2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %adj.idx2, align 4

  %n.val = load i64, i64* %n, align 8
  ; adj[n] = 1
  %idx.n = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %n.val
  store i32 1, i32* %idx.n, align 4
  ; adj[2n] = 1
  %2n = shl i64 %n.val, 1
  %idx.2n = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %2n
  store i32 1, i32* %idx.2n, align 4
  ; adj[n+3] = 1
  %n.plus3 = add i64 %n.val, 3
  %idx.n3 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %n.plus3
  store i32 1, i32* %idx.n3, align 4
  ; adj[3n+1] = 1
  %3n = add i64 %2n, %n.val
  %3n.plus1 = add i64 %3n, 1
  %idx.3n1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %3n.plus1
  store i32 1, i32* %idx.3n1, align 4
  ; adj[n+4] = 1
  %n.plus4 = add i64 %n.val, 4
  %idx.n4 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %n.plus4
  store i32 1, i32* %idx.n4, align 4
  ; adj[4n+1] = 1
  %4n = shl i64 %n.val, 2
  %4n.plus1 = add i64 %4n, 1
  %idx.4n1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %4n.plus1
  store i32 1, i32* %idx.4n1, align 4
  ; adj[2n+5] = 1
  %2n.plus5 = add i64 %2n, 5
  %idx.2n5 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %2n.plus5
  store i32 1, i32* %idx.2n5, align 4
  ; adj[5n+2] = 1
  %5n = add i64 %4n, %n.val
  %5n.plus2 = add i64 %5n, 2
  %idx.5n2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %5n.plus2
  store i32 1, i32* %idx.5n2, align 4
  ; adj[4n+5] = 1
  %4n.plus5 = add i64 %4n, 5
  %idx.4n5 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %4n.plus5
  store i32 1, i32* %idx.4n5, align 4
  ; adj[5n+4] = 1
  %5n.plus4 = add i64 %5n, 4
  %idx.5n4 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %5n.plus4
  store i32 1, i32* %idx.5n4, align 4
  ; adj[5n+6] = 1
  %5n.plus6 = add i64 %5n, 6
  %idx.5n6 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %5n.plus6
  store i32 1, i32* %idx.5n6, align 4
  ; adj[6n+5] = 1
  %6n = shl i64 %3n, 1
  %6n.plus5 = add i64 %6n, 5
  %idx.6n5 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %6n.plus5
  store i32 1, i32* %idx.6n5, align 4

  ; start = 0; out_len = 0
  store i64 0, i64* %start, align 8
  store i64 0, i64* %out_len, align 8

  ; call dfs(adj, n, start, out, &out_len)
  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %out.base = getelementptr inbounds [64 x i64], [64 x i64]* %out, i64 0, i64 0
  %n.arg = load i64, i64* %n, align 8
  %start.arg = load i64, i64* %start, align 8
  call void @dfs(i32* %adj.base, i64 %n.arg, i64 %start.arg, i64* %out.base, i64* %out_len)

  ; printf("DFS preorder from %zu: ", start)
  %fmt.pre = getelementptr inbounds [24 x i8], [24 x i8]* @.str.pre, i64 0, i64 0
  %start.print = load i64, i64* %start, align 8
  %call.pre = call i32 (i8*, ...) @_printf(i8* %fmt.pre, i64 %start.print)

  ; for (i = 0; i < out_len; ++i) printf("%zu%s", out[i], (i+1<out_len)?" ":"")
  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:
  %i.cur = load i64, i64* %i, align 8
  %len.cur = load i64, i64* %out_len, align 8
  %cmp = icmp ult i64 %i.cur, %len.cur
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:
  ; choose suffix
  %i.plus1 = add i64 %i.cur, 1
  %spc.cond = icmp ult i64 %i.plus1, %len.cur
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  %suffix = select i1 %spc.cond, i8* %space.ptr, i8* %empty.ptr

  ; value = out[i]
  %out.elem.ptr = getelementptr inbounds [64 x i64], [64 x i64]* %out, i64 0, i64 %i.cur
  %out.val = load i64, i64* %out.elem.ptr, align 8

  ; printf("%zu%s", value, suffix)
  %fmt.item = getelementptr inbounds [6 x i8], [6 x i8]* @.str.item, i64 0, i64 0
  %call.item = call i32 (i8*, ...) @_printf(i8* %fmt.item, i64 %out.val, i8* %suffix)

  ; i++
  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop.cond

loop.end:
  ; putchar('\n')
  %putc = call i32 @_putchar(i32 10)

  ; stack protector epilogue
  %guard.end = load i64, i64* @__stack_chk_guard, align 8
  %guard.saved = load i64, i64* %canary, align 8
  %ok = icmp eq i64 %guard.end, %guard.saved
  br i1 %ok, label %ret.ok, label %ret.fail

ret.fail:
  call void @___stack_chk_fail()
  br label %ret.ok

ret.ok:
  ret i32 0
}