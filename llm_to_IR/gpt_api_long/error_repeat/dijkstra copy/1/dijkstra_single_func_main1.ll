; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x401420
; Intent: Read graph (n,m), build 100x100 adjacency matrix, then run Dijkstra from a source (confidence=0.90). Evidence: symmetric matrix writes with 0x190 stride (100 ints/row), final call to dijkstra(matrix, n, src)
; Preconditions: 0 <= n <= 100; 0 <= u,v < 100 for all edges; m >= 0; input conforms to scanf formats.
; Postconditions: Adjacency matrix zero-initialized; edges set symmetrically; calls dijkstra with base pointer to matrix, vertex count n, and source.

@.fmt2 = private unnamed_addr constant [6 x i8] c"%d %d\00"
@.fmt3 = private unnamed_addr constant [9 x i8] c"%d %d %d\00"
@.fmt1 = private unnamed_addr constant [3 x i8] c"%d\00"

declare i32 @__isoc99_scanf(i8*, ...)
declare i8* @memset(i8*, i32, i64)
declare void @dijkstra(i32*, i32, i32)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %matrix = alloca [100 x [100 x i32]]
  %n = alloca i32
  %m = alloca i32
  %u = alloca i32
  %v = alloca i32
  %w = alloca i32
  %src = alloca i32
  %fmt2ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.fmt2, i64 0, i64 0
  %fmt3ptr = getelementptr inbounds [9 x i8], [9 x i8]* @.fmt3, i64 0, i64 0
  %fmt1ptr = getelementptr inbounds [3 x i8], [3 x i8]* @.fmt1, i64 0, i64 0
  %call0 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt2ptr, i32* %n, i32* %m)
  %mat_i8 = bitcast [100 x [100 x i32]]* %matrix to i8*
  %memset_call = call i8* @memset(i8* %mat_i8, i32 0, i64 40000)
  br label %loop.header

loop.header:                                        ; preds = %loop.body, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.body ]
  %mval = load i32, i32* %m
  %cmp = icmp sge i32 %i, %mval
  br i1 %cmp, label %after.loop, label %loop.body

loop.body:                                          ; preds = %loop.header
  %call1 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt3ptr, i32* %u, i32* %v, i32* %w)
  %u.val = load i32, i32* %u
  %v.val = load i32, i32* %v
  %w.val = load i32, i32* %w
  %u64 = sext i32 %u.val to i64
  %v64 = sext i32 %v.val to i64
  %row_u = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %matrix, i64 0, i64 %u64
  %cell_uv = getelementptr inbounds [100 x i32], [100 x i32]* %row_u, i64 0, i64 %v64
  store i32 %w.val, i32* %cell_uv
  %row_v = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %matrix, i64 0, i64 %v64
  %cell_vu = getelementptr inbounds [100 x i32], [100 x i32]* %row_v, i64 0, i64 %u64
  store i32 %w.val, i32* %cell_vu
  %i.next = add nsw i32 %i, 1
  br label %loop.header

after.loop:                                         ; preds = %loop.header
  %call2 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt1ptr, i32* %src)
  %nval = load i32, i32* %n
  %srcval = load i32, i32* %src
  %base = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %matrix, i64 0, i64 0, i64 0
  call void @dijkstra(i32* %base, i32 %nval, i32 %srcval)
  ret i32 0
}