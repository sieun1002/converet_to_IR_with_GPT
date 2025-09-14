; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x401420
; Intent: Read n,m; read m undirected weighted edges into 100x100 adjacency matrix; read start; run dijkstra(matrix, n, start) (confidence=0.86). Evidence: symmetrical matrix assignments with 0x190-byte row stride (100 ints), call to dijkstra with (matrix, first scanf int, last scanf int).
; Preconditions: 0 <= n <= 100; all vertex indices in [0,99]; m >= 0 and fits loop bounds.
; Postconditions: Calls dijkstra with the constructed adjacency matrix.

@.str.dd = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.str.ddd = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1
@.str.d = private unnamed_addr constant [3 x i8] c"%d\00", align 1

; Only the necessary external declarations:
declare i32 @__isoc99_scanf(i8*, ...)
declare i8* @memset(i8*, i32, i64)
declare void @dijkstra(i32*, i32, i32)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %s = alloca [100 x [100 x i32]], align 16
  %n = alloca i32, align 4
  %m = alloca i32, align 4
  %u = alloca i32, align 4
  %v = alloca i32, align 4
  %w = alloca i32, align 4
  %start = alloca i32, align 4
  %i = alloca i32, align 4

  %fmt1 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.dd, i64 0, i64 0
  %call0 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt1, i32* %n, i32* %m)

  %s.i8 = bitcast [100 x [100 x i32]]* %s to i8*
  %mem = call i8* @memset(i8* %s.i8, i32 0, i64 40000)

  store i32 0, i32* %i, align 4
  br label %loop

loop:                                             ; preds = %loop.body, %entry
  %i.val = load i32, i32* %i, align 4
  %m.val = load i32, i32* %m, align 4
  %cmp = icmp slt i32 %i.val, %m.val
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:                                        ; preds = %loop
  %fmt2 = getelementptr inbounds [9 x i8], [9 x i8]* @.str.ddd, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt2, i32* %u, i32* %v, i32* %w)

  %wval = load i32, i32* %w, align 4
  %u32 = load i32, i32* %u, align 4
  %u64 = sext i32 %u32 to i64
  %v32 = load i32, i32* %v, align 4
  %v64 = sext i32 %v32 to i64

  %row.u = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %u64
  %cell.uv = getelementptr inbounds [100 x i32], [100 x i32]* %row.u, i64 0, i64 %v64
  store i32 %wval, i32* %cell.uv, align 4

  %row.v = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %v64
  %cell.vu = getelementptr inbounds [100 x i32], [100 x i32]* %row.v, i64 0, i64 %u64
  store i32 %wval, i32* %cell.vu, align 4

  %inc = add nsw i32 %i.val, 1
  store i32 %inc, i32* %i, align 4
  br label %loop

after.loop:                                       ; preds = %loop
  %fmt3 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.d, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt3, i32* %start)

  %s.base = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 0, i64 0
  %n.load = load i32, i32* %n, align 4
  %start.load = load i32, i32* %start, align 4
  call void @dijkstra(i32* %s.base, i32 %n.load, i32 %start.load)

  ret i32 0
}