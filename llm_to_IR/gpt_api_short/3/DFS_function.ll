; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x14AE
; Intent: Build a 7-node undirected graph, run DFS preorder from 0, and print the order (confidence=0.84). Evidence: call to dfs with adjacency/N/start/result buffer, and prints "DFS preorder from %zu: " then a space-separated list using "%zu%s".
; Preconditions: dfs expects: adj as 49-int (7x7) flattened matrix, N=7, start within [0,6], outputs preorder into result buffer (capacity >=7) and sets count.
; Postconditions: Prints one line with the preorder.

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)
@__stack_chk_guard = external global i64

declare void @dfs(i32*, i64, i64, i64*, i64*)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @__stack_chk_fail()
declare void @llvm.memset.p0i8.i64(i8*, i8, i64, i1)

@.fmt_hdr = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00"
@.fmt_item = private unnamed_addr constant [6 x i8] c"%zu%s\00"
@.spc = private unnamed_addr constant [2 x i8] c" \00"
@.empt = private unnamed_addr constant [1 x i8] c"\00"

define dso_local i32 @main() local_unnamed_addr {
entry:
  %canary = alloca i64, align 8
  %adj = alloca [49 x i32], align 16
  %res = alloca [8 x i64], align 16
  %count = alloca i64, align 8
  %N = alloca i64, align 8
  %start = alloca i64, align 8
  %i = alloca i64, align 8

  ; stack protector prologue
  %guard.load = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard.load, i64* %canary, align 8

  ; N = 7, start = 0, count = 0
  store i64 7, i64* %N, align 8
  store i64 0, i64* %start, align 8
  store i64 0, i64* %count, align 8

  ; zero adjacency matrix (49 * 4 = 196 bytes)
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 196, i1 false)

  ; Build undirected edges:
  ; 0<->1, 0<->2, 1<->3, 1<->4, 2<->5, 4<->5, 5<->6
  ; Also matches the exact index computations in the disassembly.

  ; adj[1] = 1
  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %adj.base, align 4
  ; adj[2] = 1
  %adj.base2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %adj.base2, align 4

  %Nval = load i64, i64* %N, align 8

  ; adj[N] = 1
  %idxN = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %Nval
  store i32 1, i32* %idxN, align 4
  ; adj[2N] = 1
  %twon = add i64 %Nval, %Nval
  %idx2N = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %twon
  store i32 1, i32* %idx2N, align 4
  ; adj[N+3] = 1
  %n_p3 = add i64 %Nval, 3
  %idxN3 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %n_p3
  store i32 1, i32* %idxN3, align 4
  ; adj[3N+1] = 1  (N + 2N + 1)
  %threen = add i64 %twon, %Nval
  %threen_p1 = add i64 %threen, 1
  %idx3N1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %threen_p1
  store i32 1, i32* %idx3N1, align 4
  ; adj[N+4] = 1
  %n_p4 = add i64 %Nval, 4
  %idxN4 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %n_p4
  store i32 1, i32* %idxN4, align 4
  ; adj[4N+1] = 1  ( (4*N) + 1 )
  %fourN = shl i64 %Nval, 2
  %fourN_p1 = add i64 %fourN, 1
  %idx4N1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %fourN_p1
  store i32 1, i32* %idx4N1, align 4
  ; adj[2N+5] = 1
  %twoN_p5 = add i64 %twon, 5
  %idx2N5 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %twoN_p5
  store i32 1, i32* %idx2N5, align 4
  ; adj[5N+2] = 1  ( (4N + N) + 2 )
  %fiveN = add i64 %fourN, %Nval
  %fiveN_p2 = add i64 %fiveN, 2
  %idx5N2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %fiveN_p2
  store i32 1, i32* %idx5N2, align 4
  ; adj[4N+5] = 1
  %fourN_p5 = add i64 %fourN, 5
  %idx4N5 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %fourN_p5
  store i32 1, i32* %idx4N5, align 4
  ; adj[5N+4] = 1
  %fiveN_p4 = add i64 %fiveN, 4
  %idx5N4 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %fiveN_p4
  store i32 1, i32* %idx5N4, align 4
  ; adj[5N+6] = 1
  %fiveN_p6 = add i64 %fiveN, 6
  %idx5N6 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %fiveN_p6
  store i32 1, i32* %idx5N6, align 4
  ; adj[6N+5] = 1  ( (3N*2) + 5 ) == ( ( (N + N) + N ) * 2 + 5 )
  %sixN = add i64 %threen, %threen
  %sixN_p5 = add i64 %sixN, 5
  %idx6N5 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %sixN_p5
  store i32 1, i32* %idx6N5, align 4

  ; Call dfs(adj, N, start, res, &count)
  %adj.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %res.ptr = getelementptr inbounds [8 x i64], [8 x i64]* %res, i64 0, i64 0
  %N.load = load i64, i64* %N, align 8
  %start.load = load i64, i64* %start, align 8
  call void @dfs(i32* %adj.ptr, i64 %N.load, i64 %start.load, i64* %res.ptr, i64* %count)

  ; printf("DFS preorder from %zu: ", start)
  %fmt_hdr.ptr = getelementptr inbounds [24 x i8], [24 x i8]* @.fmt_hdr, i64 0, i64 0
  %call_printf_hdr = call i32 (i8*, ...) @printf(i8* %fmt_hdr.ptr, i64 %start.load)

  ; i = 0
  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:
  %i.val = load i64, i64* %i, align 8
  %cnt.val = load i64, i64* %count, align 8
  %cmp = icmp ult i64 %i.val, %cnt.val
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:
  ; choose separator: " " if i+1 < count else ""
  %ip1 = add i64 %i.val, 1
  %sep.islast = icmp uge i64 %ip1, %cnt.val
  %spc.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.spc, i64 0, i64 0
  %empt.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.empt, i64 0, i64 0
  %sep = select i1 %sep.islast, i8* %empt.ptr, i8* %spc.ptr

  ; load value res[i]
  %res.elem.ptr = getelementptr inbounds [8 x i64], [8 x i64]* %res, i64 0, i64 %i.val
  %val = load i64, i64* %res.elem.ptr, align 8

  ; printf("%zu%s", val, sep)
  %fmt_item.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.fmt_item, i64 0, i64 0
  %call_printf_item = call i32 (i8*, ...) @printf(i8* %fmt_item.ptr, i64 %val, i8* %sep)

  ; i++
  %i.next = add i64 %i.val, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop.cond

loop.end:
  ; putchar('\n')
  %nl = call i32 @putchar(i32 10)

  ; stack protector epilogue
  %canary.end = load i64, i64* %canary, align 8
  %guard.end = load i64, i64* @__stack_chk_guard, align 8
  %ok = icmp eq i64 %canary.end, %guard.end
  br i1 %ok, label %ret, label %stkfail

stkfail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}