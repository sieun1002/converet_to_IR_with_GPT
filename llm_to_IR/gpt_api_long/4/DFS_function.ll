; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x14AE
; Intent: Build a 7-node undirected graph (adjacency matrix), run DFS preorder from node 0, and print the order. (confidence=0.95). Evidence: call to dfs, strings "DFS preorder from %zu: " and "%zu%s"
; Preconditions: dfs expects an n×n row-major i32 adjacency matrix (0/1), n=7 here; out buffer capacity ≥ n; out_len pointer is valid.
; Postconditions: Prints the DFS preorder followed by a newline.

@__stack_chk_guard = external global i64
@format = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00"
@aZuS = private unnamed_addr constant [6 x i8] c"%zu%s\00"
@asc_201C = private unnamed_addr constant [2 x i8] c" \00"
@unk_201E = private unnamed_addr constant [1 x i8] zeroinitializer

; Only the needed extern declarations:
declare void @dfs(i32*, i64, i64, i64*, i64*)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @__stack_chk_fail()

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %guard = load i64, i64* @__stack_chk_guard
  %adj = alloca [49 x i32], align 16
  %out = alloca [7 x i64], align 16
  %out_len = alloca i64, align 8
  store i64 0, i64* %out_len, align 8
  br label %zero.loop

zero.loop:                                        ; i in [0,49)
  %i = phi i64 [ 0, %entry ], [ %i.next, %zero.body ]
  %cmp = icmp ult i64 %i, 49
  br i1 %cmp, label %zero.body, label %zero.done

zero.body:
  %elem.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %i
  store i32 0, i32* %elem.ptr, align 4
  %i.next = add i64 %i, 1
  br label %zero.loop

zero.done:
  ; set undirected edges as 1s in the 7x7 adjacency matrix (row-major)
  %p1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %p1, align 4
  %p7 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 7
  store i32 1, i32* %p7, align 4
  %p2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %p2, align 4
  %p14 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 14
  store i32 1, i32* %p14, align 4
  %p10 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 10
  store i32 1, i32* %p10, align 4
  %p22 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 22
  store i32 1, i32* %p22, align 4
  %p11 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 11
  store i32 1, i32* %p11, align 4
  %p29 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 29
  store i32 1, i32* %p29, align 4
  %p19 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 19
  store i32 1, i32* %p19, align 4
  %p37 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 37
  store i32 1, i32* %p37, align 4
  %p33 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 33
  store i32 1, i32* %p33, align 4
  %p39 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 39
  store i32 1, i32* %p39, align 4
  %p41 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 41
  store i32 1, i32* %p41, align 4
  %p47 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 47
  store i32 1, i32* %p47, align 4

  %graph_ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %out_ptr = getelementptr inbounds [7 x i64], [7 x i64]* %out, i64 0, i64 0
  call void @dfs(i32* %graph_ptr, i64 7, i64 0, i64* %out_ptr, i64* %out_len)

  %fmt1 = getelementptr inbounds [24 x i8], [24 x i8]* @format, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt1, i64 0)

  %len = load i64, i64* %out_len, align 8
  br label %loop

loop:
  %idx = phi i64 [ 0, %zero.done ], [ %idx.next, %loop.body ]
  %cmp2 = icmp ult i64 %idx, %len
  br i1 %cmp2, label %loop.body, label %afterloop

loop.body:
  %idxp1 = add i64 %idx, 1
  %use_space = icmp ult i64 %idxp1, %len
  %space_ptr = getelementptr inbounds [2 x i8], [2 x i8]* @asc_201C, i64 0, i64 0
  %empty_ptr = getelementptr inbounds [1 x i8], [1 x i8]* @unk_201E, i64 0, i64 0
  %sep = select i1 %use_space, i8* %space_ptr, i8* %empty_ptr
  %val.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %out, i64 0, i64 %idx
  %val = load i64, i64* %val.ptr, align 8
  %fmt2 = getelementptr inbounds [6 x i8], [6 x i8]* @aZuS, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt2, i64 %val, i8* %sep)
  %idx.next = add i64 %idx, 1
  br label %loop

afterloop:
  call i32 @putchar(i32 10)
  %guard2 = load i64, i64* @__stack_chk_guard
  %ok = icmp eq i64 %guard, %guard2
  br i1 %ok, label %ret, label %stackfail

stackfail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}