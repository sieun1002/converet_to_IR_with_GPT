; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x14AE
; Intent: Build a 7-node graph adjacency matrix, run dfs preorder from 0, and print the traversal (confidence=0.90). Evidence: format strings ("DFS preorder from %zu: ", "%zu%s") and adjacency matrix initialization with 7x7 indexing.
; Preconditions: dfs(i32* adj, i64 n, i64 start, i64* out, i64* out_len) appends preorder to out and sets out_len<=n.
; Postconditions: prints preorder followed by newline; returns 0.

@.str.header = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.fmt = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1

@__stack_chk_guard = external global i64

; Only the needed extern declarations:
declare void @dfs(i32*, i64, i64, i64*, i64*)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @__stack_chk_fail()
declare void @llvm.memset.p0i8.i64(i8*, i8, i64, i1)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %canary.slot = alloca i64, align 8
  %adj = alloca [49 x i32], align 16
  %order = alloca [64 x i64], align 16
  %len = alloca i64, align 8
  %start.slot = alloca i64, align 8
  %guard0 = load i64, i64* @__stack_chk_guard
  store i64 %guard0, i64* %canary.slot, align 8

  ; memset adj[49] = 0 (196 bytes)
  %adj0 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %adj0.i8 = bitcast i32* %adj0 to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj0.i8, i8 0, i64 196, i1 false)

  ; Build edges (undirected) in 7x7 adjacency matrix
  %p1 = getelementptr inbounds i32, i32* %adj0, i64 1
  store i32 1, i32* %p1, align 4                       ; (0,1)
  %p2 = getelementptr inbounds i32, i32* %adj0, i64 2
  store i32 1, i32* %p2, align 4                       ; (0,2)
  %p7 = getelementptr inbounds i32, i32* %adj0, i64 7
  store i32 1, i32* %p7, align 4                       ; (1,0)
  %p14 = getelementptr inbounds i32, i32* %adj0, i64 14
  store i32 1, i32* %p14, align 4                      ; (2,0)
  %p10 = getelementptr inbounds i32, i32* %adj0, i64 10
  store i32 1, i32* %p10, align 4                      ; (1,3)
  %p22 = getelementptr inbounds i32, i32* %adj0, i64 22
  store i32 1, i32* %p22, align 4                      ; (3,1)
  %p11 = getelementptr inbounds i32, i32* %adj0, i64 11
  store i32 1, i32* %p11, align 4                      ; (1,4)
  %p29 = getelementptr inbounds i32, i32* %adj0, i64 29
  store i32 1, i32* %p29, align 4                      ; (4,1)
  %p19 = getelementptr inbounds i32, i32* %adj0, i64 19
  store i32 1, i32* %p19, align 4                      ; (2,5)
  %p37 = getelementptr inbounds i32, i32* %adj0, i64 37
  store i32 1, i32* %p37, align 4                      ; (5,2)
  %p33 = getelementptr inbounds i32, i32* %adj0, i64 33
  store i32 1, i32* %p33, align 4                      ; (4,5)
  %p39 = getelementptr inbounds i32, i32* %adj0, i64 39
  store i32 1, i32* %p39, align 4                      ; (5,4)
  %p41 = getelementptr inbounds i32, i32* %adj0, i64 41
  store i32 1, i32* %p41, align 4                      ; (5,6)
  %p47 = getelementptr inbounds i32, i32* %adj0, i64 47
  store i32 1, i32* %p47, align 4                      ; (6,5)

  store i64 0, i64* %start.slot, align 8
  store i64 0, i64* %len, align 8

  ; dfs(adj, 7, 0, order, &len)
  %order0 = getelementptr inbounds [64 x i64], [64 x i64]* %order, i64 0, i64 0
  call void @dfs(i32* %adj0, i64 7, i64 0, i64* %order0, i64* %len)

  ; printf("DFS preorder from %zu: ", 0)
  %hdr = getelementptr inbounds [24 x i8], [24 x i8]* @.str.header, i64 0, i64 0
  %_ph = call i32 (i8*, ...) @printf(i8* %hdr, i64 0)

  br label %loop

loop:                                             ; preds = %entry, %loop.body
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop.body ]
  %len.now = load i64, i64* %len, align 8
  %cond = icmp ult i64 %i, %len.now
  br i1 %cond, label %loop.body, label %loop.end

loop.body:                                        ; preds = %loop
  %i.next = add i64 %i, 1
  %len2 = load i64, i64* %len, align 8
  %more = icmp ult i64 %i.next, %len2
  %space = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  %empty = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  %suf = select i1 %more, i8* %space, i8* %empty

  %elem.ptr = getelementptr inbounds i64, i64* %order0, i64 %i
  %elem = load i64, i64* %elem.ptr, align 8
  %fmt = getelementptr inbounds [6 x i8], [6 x i8]* @.str.fmt, i64 0, i64 0
  %_p = call i32 (i8*, ...) @printf(i8* %fmt, i64 %elem, i8* %suf)
  br label %loop

loop.end:                                         ; preds = %loop
  %_pc = call i32 @putchar(i32 10)

  %guard1 = load i64, i64* @__stack_chk_guard
  %saved = load i64, i64* %canary.slot, align 8
  %mismatch = icmp ne i64 %saved, %guard1
  br i1 %mismatch, label %stackfail, label %ret

stackfail:                                        ; preds = %loop.end
  call void @__stack_chk_fail()
  unreachable

ret:                                              ; preds = %loop.end
  ret i32 0
}