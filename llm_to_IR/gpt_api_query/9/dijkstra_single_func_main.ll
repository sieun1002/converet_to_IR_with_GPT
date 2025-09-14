; ModuleID = 'recovered.ll'
source_filename = "recovered"
target triple = "x86_64-unknown-linux-gnu"

@.fmt2 = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.fmt3 = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1
@.fmt1 = private unnamed_addr constant [3 x i8] c"%d\00", align 1

declare i32 @__isoc99_scanf(i8*, ...)
declare i8* @memset(i8*, i32, i64)
declare void @dijkstra(i32*, i32, i32)

define dso_local i32 @main() {
entry:
  %n = alloca i32, align 4
  %m = alloca i32, align 4
  %src = alloca i32, align 4
  %u = alloca i32, align 4
  %v = alloca i32, align 4
  %w = alloca i32, align 4
  %i = alloca i32, align 4
  %s = alloca [100 x [100 x i32]], align 16

  ; scanf("%d %d", &n, &m)
  %fmt2.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.fmt2, i64 0, i64 0
  %call0 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt2.ptr, i32* %n, i32* %m)

  ; memset(s, 0, 0x9C40)
  %s.i8 = bitcast [100 x [100 x i32]]* %s to i8*
  %mem = call i8* @memset(i8* %s.i8, i32 0, i64 40000)

  store i32 0, i32* %i, align 4
  br label %loop

loop:                                             ; preds = %body, %entry
  %i.val = load i32, i32* %i, align 4
  %m.val = load i32, i32* %m, align 4
  %cmp = icmp slt i32 %i.val, %m.val
  br i1 %cmp, label %body, label %after

body:                                             ; preds = %loop
  ; scanf("%d %d %d", &u, &v, &w)
  %fmt3.ptr = getelementptr inbounds [9 x i8], [9 x i8]* @.fmt3, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt3.ptr, i32* %u, i32* %v, i32* %w)

  %u.val = load i32, i32* %u, align 4
  %v.val = load i32, i32* %v, align 4
  %w.val = load i32, i32* %w, align 4

  ; s[u][v] = w
  %u.ext = sext i32 %u.val to i64
  %v.ext = sext i32 %v.val to i64
  %row.u = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %u.ext
  %cell.uv = getelementptr inbounds [100 x i32], [100 x i32]* %row.u, i64 0, i64 %v.ext
  store i32 %w.val, i32* %cell.uv, align 4

  ; s[v][u] = w
  %row.v = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %v.ext
  %cell.vu = getelementptr inbounds [100 x i32], [100 x i32]* %row.v, i64 0, i64 %u.ext
  store i32 %w.val, i32* %cell.vu, align 4

  ; i++
  %i.next = add nsw i32 %i.val, 1
  store i32 %i.next, i32* %i, align 4
  br label %loop

after:                                            ; preds = %loop
  ; scanf("%d", &src)
  %fmt1.ptr = getelementptr inbounds [3 x i8], [3 x i8]* @.fmt1, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt1.ptr, i32* %src)

  ; dijkstra(&s[0][0], n, src)
  %base = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 0, i64 0
  %n.load = load i32, i32* %n, align 4
  %src.load = load i32, i32* %src, align 4
  call void @dijkstra(i32* %base, i32 %n.load, i32 %src.load)

  ret i32 0
}