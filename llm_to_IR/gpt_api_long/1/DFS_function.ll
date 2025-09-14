; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x14AE
; Intent: Build a small adjacency matrix (N=7), call dfs to compute a preorder from start=0, and print it (confidence=0.83). Evidence: call to dfs with flattened NxN int matrix and printing "DFS preorder" with %zu elements.
; Preconditions: dfs expects a flattened row-major NxN adjacency matrix (i32 entries), N=7; output buffer holds up to 8 size_t entries; out_len pointer updated by dfs.
; Postconditions: Prints the DFS preorder and a newline; returns 0.

@.str.pre = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str.fmt2 = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1

; Only the needed extern declarations:
declare void @dfs(i32*, i64, i64, i64*, i64*)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @__stack_chk_fail()
declare void @llvm.memset.p0i8.i64(i8*, i8, i64, i1)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %saved_canary = alloca i64, align 8
  %adj = alloca [48 x i32], align 16
  %visited = alloca [8 x i64], align 16
  %out_len = alloca i64, align 8
  %i = alloca i64, align 8
  %n = alloca i64, align 8
  %start = alloca i64, align 8

  %canary0 = call i64 asm "movq %fs:0x28, $0", "={rax}"()
  store i64 %canary0, i64* %saved_canary, align 8

  store i64 7, i64* %n, align 8
  %adj_i8 = bitcast [48 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj_i8, i8 0, i64 192, i1 false)

  ; Set specific adjacency entries to 1
  %adj.base = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 0
  %p1 = getelementptr inbounds i32, i32* %adj.base, i64 7
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %adj.base, i64 14
  store i32 1, i32* %p2, align 4
  %p3 = getelementptr inbounds i32, i32* %adj.base, i64 10
  store i32 1, i32* %p3, align 4
  %p4 = getelementptr inbounds i32, i32* %adj.base, i64 22
  store i32 1, i32* %p4, align 4
  %p5 = getelementptr inbounds i32, i32* %adj.base, i64 11
  store i32 1, i32* %p5, align 4
  %p6 = getelementptr inbounds i32, i32* %adj.base, i64 29
  store i32 1, i32* %p6, align 4
  %p7 = getelementptr inbounds i32, i32* %adj.base, i64 19
  store i32 1, i32* %p7, align 4
  %p8 = getelementptr inbounds i32, i32* %adj.base, i64 37
  store i32 1, i32* %p8, align 4
  %p9 = getelementptr inbounds i32, i32* %adj.base, i64 33
  store i32 1, i32* %p9, align 4
  %p10 = getelementptr inbounds i32, i32* %adj.base, i64 39
  store i32 1, i32* %p10, align 4
  %p11 = getelementptr inbounds i32, i32* %adj.base, i64 41
  store i32 1, i32* %p11, align 4
  %p12 = getelementptr inbounds i32, i32* %adj.base, i64 47
  store i32 1, i32* %p12, align 4

  store i64 0, i64* %start, align 8
  store i64 0, i64* %out_len, align 8

  %adj.ptr = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 0
  %visited.ptr = getelementptr inbounds [8 x i64], [8 x i64]* %visited, i64 0, i64 0
  %nval = load i64, i64* %n, align 8
  %startval = load i64, i64* %start, align 8
  call void @dfs(i32* %adj.ptr, i64 %nval, i64 %startval, i64* %visited.ptr, i64* %out_len)

  %fmt1 = getelementptr inbounds [24 x i8], [24 x i8]* @.str.pre, i64 0, i64 0
  %startval2 = load i64, i64* %start, align 8
  %call.printf1 = call i32 (i8*, ...) @printf(i8* %fmt1, i64 %startval2)

  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:                                          ; preds = %sel.join, %entry
  %i.cur = load i64, i64* %i, align 8
  %len.cur = load i64, i64* %out_len, align 8
  %cont = icmp ult i64 %i.cur, %len.cur
  br i1 %cont, label %loop.body, label %loop.end

loop.body:                                          ; preds = %loop.cond
  %i1 = load i64, i64* %i, align 8
  %i1p1 = add i64 %i1, 1
  %len2 = load i64, i64* %out_len, align 8
  %is_last = icmp uge i64 %i1p1, %len2
  br i1 %is_last, label %sel.empty, label %sel.space

sel.space:                                          ; preds = %loop.body
  %spaceptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  br label %sel.join

sel.empty:                                          ; preds = %loop.body
  %emptyptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  br label %sel.join

sel.join:                                           ; preds = %sel.empty, %sel.space
  %sep = phi i8* [ %spaceptr, %sel.space ], [ %emptyptr, %sel.empty ]
  %i2 = load i64, i64* %i, align 8
  %valptr = getelementptr inbounds [8 x i64], [8 x i64]* %visited, i64 0, i64 %i2
  %val = load i64, i64* %valptr, align 8
  %fmt2 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.fmt2, i64 0, i64 0
  %call.printf2 = call i32 (i8*, ...) @printf(i8* %fmt2, i64 %val, i8* %sep)
  %i.next = add i64 %i2, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop.cond

loop.end:                                           ; preds = %loop.cond
  %putc = call i32 @putchar(i32 10)
  %canary1 = call i64 asm "movq %fs:0x28, $0", "={rax}"()
  %saved = load i64, i64* %saved_canary, align 8
  %ok = icmp eq i64 %saved, %canary1
  br i1 %ok, label %ret, label %stackfail

stackfail:                                          ; preds = %loop.end
  call void @__stack_chk_fail()
  unreachable

ret:                                                ; preds = %loop.end
  ret i32 0
}