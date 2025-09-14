; ModuleID = 'recovered'
target triple = "x86_64-pc-linux-gnu"

@.str2 = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.str3 = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1
@.str1 = private unnamed_addr constant [3 x i8] c"%d\00", align 1

declare i32 @__isoc99_scanf(i8*, ...)
declare void @dijkstra([100 x i32]*, i32, i32)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define i32 @main() {
entry:
  %retvar = alloca i32, align 4
  %n = alloca i32, align 4
  %m = alloca i32, align 4
  %s = alloca [100 x [100 x i32]], align 16
  %i = alloca i32, align 4
  %u = alloca i32, align 4
  %v = alloca i32, align 4
  %w = alloca i32, align 4
  %src = alloca i32, align 4

  store i32 0, i32* %retvar, align 4

  ; scanf("%d %d", &n, &m)
  %fmt12 = getelementptr inbounds [6 x i8], [6 x i8]* @.str2, i64 0, i64 0
  %sc1 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt12, i32* %n, i32* %m)

  ; memset(s, 0, 0x9C40)
  %s_i8 = bitcast [100 x [100 x i32]]* %s to i8*
  call void @llvm.memset.p0i8.i64(i8* %s_i8, i8 0, i64 40000, i1 false)

  store i32 0, i32* %i, align 4
  br label %loop

loop:
  %i.val = load i32, i32* %i, align 4
  %m.val = load i32, i32* %m, align 4
  %cmp = icmp sge i32 %i.val, %m.val
  br i1 %cmp, label %after, label %body

body:
  ; scanf("%d %d %d", &u, &v, &w)
  %fmt3 = getelementptr inbounds [9 x i8], [9 x i8]* @.str3, i64 0, i64 0
  %sc2 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt3, i32* %u, i32* %v, i32* %w)

  ; s[u][v] = w
  %u32 = load i32, i32* %u, align 4
  %u64 = sext i32 %u32 to i64
  %rowU = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %u64
  %v32 = load i32, i32* %v, align 4
  %v64 = sext i32 %v32 to i64
  %eltUV = getelementptr inbounds [100 x i32], [100 x i32]* %rowU, i64 0, i64 %v64
  %w32a = load i32, i32* %w, align 4
  store i32 %w32a, i32* %eltUV, align 4

  ; s[v][u] = w
  %rowV = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %v64
  %eltVU = getelementptr inbounds [100 x i32], [100 x i32]* %rowV, i64 0, i64 %u64
  %w32b = load i32, i32* %w, align 4
  store i32 %w32b, i32* %eltVU, align 4

  ; i++
  %i.next = add nsw i32 %i.val, 1
  store i32 %i.next, i32* %i, align 4
  br label %loop

after:
  ; scanf("%d", &src)
  %fmt1 = getelementptr inbounds [3 x i8], [3 x i8]* @.str1, i64 0, i64 0
  %sc3 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt1, i32* %src)

  ; dijkstra(s, n, src)
  %row0 = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 0
  %n.val = load i32, i32* %n, align 4
  %src.val = load i32, i32* %src, align 4
  call void @dijkstra([100 x i32]* %row0, i32 %n.val, i32 %src.val)

  ret i32 0
}