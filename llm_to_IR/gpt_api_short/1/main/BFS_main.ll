; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x13DD
; Intent: Build a 7x7 adjacency matrix, run BFS from node 0, and print order and distances (confidence=0.88). Evidence: call to bfs with matrix/n/start/dist/order/len, followed by printf patterns for BFS order and distances.
; Preconditions: bfs(int*, size_t, size_t, int*, size_t*, size_t*) must match the expected ABI and fill order/len/dist appropriately.
; Postconditions: Prints BFS order and per-node distances; returns 0.

@.str.bfs = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.zu_s = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

; Only the necessary external declarations:
declare void @bfs(i32*, i64, i64, i32*, i64*, i64*) local_unnamed_addr
declare i32 @printf(i8*, ...) local_unnamed_addr
declare i32 @putchar(i32) local_unnamed_addr
declare void @__stack_chk_fail() local_unnamed_addr
declare void @llvm.memset.p0i8.i64(i8*, i8, i64, i1 immarg)

define dso_local i32 @main() local_unnamed_addr {
entry:
  %canary = alloca i64, align 8
  %adj = alloca [49 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [49 x i64], align 16
  %n = alloca i64, align 8
  %start = alloca i64, align 8
  %out_len = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  store i64 0, i64* %canary, align 8

  store i64 7, i64* %n, align 8

  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 196, i1 false)

  ; set adjacency matrix entries to 1
  %adj.idx1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %adj.idx1, align 4
  %adj.idx2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %adj.idx2, align 4
  %adj.idx7 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 7
  store i32 1, i32* %adj.idx7, align 4
  %adj.idx10 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 10
  store i32 1, i32* %adj.idx10, align 4
  %adj.idx11 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 11
  store i32 1, i32* %adj.idx11, align 4
  %adj.idx14 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 14
  store i32 1, i32* %adj.idx14, align 4
  %adj.idx19 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 19
  store i32 1, i32* %adj.idx19, align 4
  %adj.idx22 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 22
  store i32 1, i32* %adj.idx22, align 4
  %adj.idx29 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 29
  store i32 1, i32* %adj.idx29, align 4
  %adj.idx33 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 33
  store i32 1, i32* %adj.idx33, align 4
  %adj.idx37 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 37
  store i32 1, i32* %adj.idx37, align 4
  %adj.idx39 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 39
  store i32 1, i32* %adj.idx39, align 4
  %adj.idx41 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 41
  store i32 1, i32* %adj.idx41, align 4
  %adj.idx47 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 47
  store i32 1, i32* %adj.idx47, align 4

  store i64 0, i64* %start, align 8
  store i64 0, i64* %out_len, align 8

  %dist.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %order.ptr = getelementptr inbounds [49 x i64], [49 x i64]* %order, i64 0, i64 0
  %adj.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %nval = load i64, i64* %n, align 8
  %sval = load i64, i64* %start, align 8
  call void @bfs(i32* %adj.ptr, i64 %nval, i64 %sval, i32* %dist.ptr, i64* %order.ptr, i64* %out_len)

  %fmt0 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.bfs, i64 0, i64 0
  %sval2 = load i64, i64* %start, align 8
  %call0 = call i32 (i8*, ...) @printf(i8* %fmt0, i64 %sval2)

  store i64 0, i64* %j, align 8
  br label %loop_j

loop_j:                                           ; preds = %body_j, %entry
  %jv = load i64, i64* %j, align 8
  %len = load i64, i64* %out_len, align 8
  %cmp = icmp ult i64 %jv, %len
  br i1 %cmp, label %body_j, label %after_j

body_j:                                           ; preds = %loop_j
  %jplus = add i64 %jv, 1
  %len2 = load i64, i64* %out_len, align 8
  %cond = icmp ult i64 %jplus, %len2
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  %sep = select i1 %cond, i8* %space.ptr, i8* %empty.ptr
  %ord.j.ptr = getelementptr inbounds [49 x i64], [49 x i64]* %order, i64 0, i64 %jv
  %ord.j = load i64, i64* %ord.j.ptr, align 8
  %fmt1 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.zu_s, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt1, i64 %ord.j, i8* %sep)
  %jnext = add i64 %jv, 1
  store i64 %jnext, i64* %j, align 8
  br label %loop_j

after_j:                                          ; preds = %loop_j
  %nl = call i32 @putchar(i32 10)

  store i64 0, i64* %i, align 8
  br label %loop_i

loop_i:                                           ; preds = %body_i, %after_j
  %iv = load i64, i64* %i, align 8
  %ncur = load i64, i64* %n, align 8
  %lt = icmp ult i64 %iv, %ncur
  br i1 %lt, label %body_i, label %after_i

body_i:                                           ; preds = %loop_i
  %dptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %iv
  %dval32 = load i32, i32* %dptr, align 4
  %fmt2 = getelementptr inbounds [23 x i8], [23 x i8]* @.str.dist, i64 0, i64 0
  %startv = load i64, i64* %start, align 8
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt2, i64 %startv, i64 %iv, i32 %dval32)
  %inext = add i64 %iv, 1
  store i64 %inext, i64* %i, align 8
  br label %loop_i

after_i:                                          ; preds = %loop_i
  %c1 = load i64, i64* %canary, align 8
  %c2 = load i64, i64* %canary, align 8
  %cmpc = icmp eq i64 %c1, %c2
  br i1 %cmpc, label %ret, label %stackfail

stackfail:                                        ; preds = %after_i
  call void @__stack_chk_fail()
  br label %ret

ret:                                              ; preds = %stackfail, %after_i
  ret i32 0
}