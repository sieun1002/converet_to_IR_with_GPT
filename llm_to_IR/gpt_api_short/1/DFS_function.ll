; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x14AE
; Intent: Build a 7-node graph adjacency matrix, run DFS preorder from node 0, and print the result (confidence=0.78). Evidence: call to dfs with (adjacency,n,start,out,len); printf with "DFS preorder from %zu: " and loop over results printing "%zu%s"
; Preconditions: none
; Postconditions: prints DFS preorder from node 0

; Only the necessary external declarations:
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @dfs(i32*, i64, i64, i64*, i64*)
declare void @llvm.memset.p0i8.i64(i8*, i8, i64, i1)

@.str.header = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00"
@.str.space  = private unnamed_addr constant [2 x i8] c" \00"
@.str.empty  = private unnamed_addr constant [1 x i8] c"\00"
@.str.item   = private unnamed_addr constant [6 x i8] c"%zu%s\00"

define dso_local i32 @main() local_unnamed_addr {
entry:
  ; locals
  %adj = alloca [49 x i32], align 16
  %out = alloca [8 x i64], align 16
  %len = alloca i64, align 8
  %n = alloca i64, align 8
  %start = alloca i64, align 8
  %idx = alloca i64, align 8

  ; n = 7; start = 0; len = 0
  store i64 7, i64* %n, align 8
  store i64 0, i64* %start, align 8
  store i64 0, i64* %len, align 8

  ; zero adjacency matrix (49 ints = 196 bytes)
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 196, i1 false)

  ; set adjacency entries to 1 (column-major index j*7 + i)
  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %p1 = getelementptr inbounds i32, i32* %adj.base, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %adj.base, i64 2
  store i32 1, i32* %p2, align 4
  %p7 = getelementptr inbounds i32, i32* %adj.base, i64 7
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
  %adj.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %out.ptr = getelementptr inbounds [8 x i64], [8 x i64]* %out, i64 0, i64 0
  %n.val = load i64, i64* %n, align 8
  %start.val = load i64, i64* %start, align 8
  call void @dfs(i32* %adj.ptr, i64 %n.val, i64 %start.val, i64* %out.ptr, i64* %len)

  ; printf("DFS preorder from %zu: ", start)
  %fmt.header = getelementptr inbounds [24 x i8], [24 x i8]* @.str.header, i64 0, i64 0
  %call.header = call i32 (i8*, ...) @printf(i8* %fmt.header, i64 %start.val)

  ; for (idx = 0; idx < len; ++idx) printf("%zu%s", out[idx], (idx+1 < len ? " " : ""));
  store i64 0, i64* %idx, align 8
  br label %loop.cond

loop.cond:                                         ; preds = %loop.body, %entry
  %idx.cur = load i64, i64* %idx, align 8
  %len.cur = load i64, i64* %len, align 8
  %cmp = icmp ult i64 %idx.cur, %len.cur
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:                                         ; preds = %loop.cond
  ; choose separator
  %next = add i64 %idx.cur, 1
  %has_more = icmp ult i64 %next, %len.cur
  %sep.space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  %sep.empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  %sep.ptr = select i1 %has_more, i8* %sep.space.ptr, i8* %sep.empty.ptr

  ; load value
  %out.elem.ptr = getelementptr inbounds [8 x i64], [8 x i64]* %out, i64 0, i64 %idx.cur
  %val = load i64, i64* %out.elem.ptr, align 8

  ; printf("%zu%s", val, sep)
  %fmt.item = getelementptr inbounds [6 x i8], [6 x i8]* @.str.item, i64 0, i64 0
  %call.item = call i32 (i8*, ...) @printf(i8* %fmt.item, i64 %val, i8* %sep.ptr)

  ; idx++
  %idx.next = add i64 %idx.cur, 1
  store i64 %idx.next, i64* %idx, align 8
  br label %loop.cond

loop.end:                                          ; preds = %loop.cond
  ; newline
  %call.nl = call i32 @putchar(i32 10)
  ret i32 0
}