; ModuleID = 'recovered_main'
target triple = "x86_64-pc-linux-gnu"

@.str.two = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.str.three = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1
@.str.one = private unnamed_addr constant [3 x i8] c"%d\00", align 1

declare i32 @__isoc99_scanf(i8*, ...)
declare i8* @memset(i8*, i32, i64)
declare void @dijkstra(i32*, i32, i32)

define i32 @main(i32 %argc, i8** %argv) {
entry:
  ; locals
  %s = alloca [100 x [100 x i32]], align 16
  %n = alloca i32, align 4
  %m = alloca i32, align 4
  %e = alloca i32, align 4
  %vi = alloca i32, align 4
  %vj = alloca i32, align 4
  %vw = alloca i32, align 4
  %src = alloca i32, align 4

  ; scanf("%d %d", &n, &m)
  %fmt2 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.two, i64 0, i64 0
  %n.ptr = bitcast i32* %n to i8*
  %m.ptr = bitcast i32* %m to i8*
  %call0 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt2, i32* %n, i32* %m)

  ; memset(s, 0, 40000)
  %s.i8 = bitcast [100 x [100 x i32]]* %s to i8*
  %mem = call i8* @memset(i8* %s.i8, i32 0, i64 40000)

  ; e = 0
  store i32 0, i32* %e, align 4
  br label %loop.cond

loop.cond:
  %e.val = load i32, i32* %e, align 4
  %m.val = load i32, i32* %m, align 4
  %cmp = icmp slt i32 %e.val, %m.val
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:
  ; scanf("%d %d %d", &vi, &vj, &vw)
  %fmt3 = getelementptr inbounds [9 x i8], [9 x i8]* @.str.three, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt3, i32* %vi, i32* %vj, i32* %vw)

  ; load values
  %ii = load i32, i32* %vi, align 4
  %jj = load i32, i32* %vj, align 4
  %ww = load i32, i32* %vw, align 4

  ; s[ii][jj] = ww
  %ii64 = sext i32 %ii to i64
  %jj64 = sext i32 %jj to i64
  %row.ptr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %ii64
  %elem.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %row.ptr, i64 0, i64 %jj64
  store i32 %ww, i32* %elem.ptr, align 4

  ; s[jj][ii] = ww
  %row.ptr2 = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %jj64
  %elem.ptr2 = getelementptr inbounds [100 x i32], [100 x i32]* %row.ptr2, i64 0, i64 %ii64
  store i32 %ww, i32* %elem.ptr2, align 4

  ; e++
  %e.next = add nsw i32 %e.val, 1
  store i32 %e.next, i32* %e, align 4
  br label %loop.cond

after.loop:
  ; scanf("%d", &src)
  %fmt1 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.one, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt1, i32* %src)

  ; dijkstra(&s[0][0], n, src)
  %flat = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 0, i64 0
  %n.val = load i32, i32* %n, align 4
  %src.val = load i32, i32* %src, align 4
  call void @dijkstra(i32* %flat, i32 %n.val, i32 %src.val)

  ret i32 0
}