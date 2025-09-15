; LLVM 14 IR for the provided main disassembly

@.str.two = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.str.three = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1
@.str.one = private unnamed_addr constant [3 x i8] c"%d\00", align 1

declare i32 @__isoc99_scanf(i8*, ...)
declare i8* @memset(i8*, i32, i64)
declare void @dijkstra(i32*, i32, i32)

define i32 @main() {
entry:
  %s = alloca [100 x [100 x i32]], align 16
  %n = alloca i32, align 4
  %m = alloca i32, align 4
  %i = alloca i32, align 4
  %u = alloca i32, align 4
  %v = alloca i32, align 4
  %w = alloca i32, align 4
  %src = alloca i32, align 4

  store i32 0, i32* %i, align 4

  ; scanf("%d %d", &n, &m)
  %fmt_two = getelementptr inbounds [6 x i8], [6 x i8]* @.str.two, i64 0, i64 0
  %call_scanf0 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt_two, i32* %n, i32* %m)

  ; memset(s, 0, 0x9C40)
  %s.base0 = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 0, i64 0
  %s.byteptr = bitcast i32* %s.base0 to i8*
  %memclr = call i8* @memset(i8* %s.byteptr, i32 0, i64 40000)

  store i32 0, i32* %i, align 4
  br label %loop

loop:
  %i.cur = load i32, i32* %i, align 4
  %m.val = load i32, i32* %m, align 4
  %cmp = icmp sge i32 %i.cur, %m.val
  br i1 %cmp, label %after, label %body

body:
  ; scanf("%d %d %d", &u, &v, &w)
  %fmt_three = getelementptr inbounds [9 x i8], [9 x i8]* @.str.three, i64 0, i64 0
  %call_scanf1 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt_three, i32* %u, i32* %v, i32* %w)

  %u.val = load i32, i32* %u, align 4
  %v.val = load i32, i32* %v, align 4
  %w.val = load i32, i32* %w, align 4
  %u64 = sext i32 %u.val to i64
  %v64 = sext i32 %v.val to i64

  ; s[u][v] = w
  %rowptr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %u64
  %cellptr = getelementptr inbounds [100 x i32], [100 x i32]* %rowptr, i64 0, i64 %v64
  store i32 %w.val, i32* %cellptr, align 4

  ; s[v][u] = w
  %rowptr2 = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %v64
  %cellptr2 = getelementptr inbounds [100 x i32], [100 x i32]* %rowptr2, i64 0, i64 %u64
  store i32 %w.val, i32* %cellptr2, align 4

  %i.next = add nsw i32 %i.cur, 1
  store i32 %i.next, i32* %i, align 4
  br label %loop

after:
  ; scanf("%d", &src)
  %fmt_one = getelementptr inbounds [3 x i8], [3 x i8]* @.str.one, i64 0, i64 0
  %call_scanf2 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt_one, i32* %src)

  ; dijkstra(s, n, src)
  %s.base = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 0, i64 0
  %n.load = load i32, i32* %n, align 4
  %src.load = load i32, i32* %src, align 4
  call void @dijkstra(i32* %s.base, i32 %n.load, i32 %src.load)

  ret i32 0
}