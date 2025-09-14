; ModuleID = 'recovered_from_disassembly'
target triple = "x86_64-pc-linux-gnu"

@.str_two = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.str_three = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1
@.str_one = private unnamed_addr constant [3 x i8] c"%d\00", align 1

declare i32 @__isoc99_scanf(i8*, ...)
declare i8* @memset(i8*, i32, i64)
declare void @dijkstra(i32*, i32, i32)

define i32 @main() {
entry:
  %n = alloca i32, align 4
  %m = alloca i32, align 4
  %s = alloca [100 x [100 x i32]], align 16
  %i = alloca i32, align 4
  %x = alloca i32, align 4
  %y = alloca i32, align 4
  %w = alloca i32, align 4
  %start = alloca i32, align 4

  ; scanf("%d %d", &n, &m)
  %fmt2 = getelementptr inbounds [6 x i8], [6 x i8]* @.str_two, i64 0, i64 0
  %scan2 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt2, i32* %n, i32* %m)

  ; memset(s, 0, 0x9C40)
  %s_i8 = bitcast [100 x [100 x i32]]* %s to i8*
  %mem = call i8* @memset(i8* %s_i8, i32 0, i64 40000)

  store i32 0, i32* %i, align 4
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %i.val = load i32, i32* %i, align 4
  %m.val = load i32, i32* %m, align 4
  %cmp = icmp slt i32 %i.val, %m.val
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:                                        ; preds = %loop.cond
  ; scanf("%d %d %d", &x, &y, &w)
  %fmt3 = getelementptr inbounds [9 x i8], [9 x i8]* @.str_three, i64 0, i64 0
  %scan3 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt3, i32* %x, i32* %y, i32* %w)

  ; s[x][y] = w
  %x.val = load i32, i32* %x, align 4
  %y.val = load i32, i32* %y, align 4
  %w.val = load i32, i32* %w, align 4
  %x.idx = sext i32 %x.val to i64
  %y.idx = sext i32 %y.val to i64
  %ptr_xy = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %x.idx, i64 %y.idx
  store i32 %w.val, i32* %ptr_xy, align 4

  ; s[y][x] = w
  %ptr_yx = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %y.idx, i64 %x.idx
  store i32 %w.val, i32* %ptr_yx, align 4

  ; i++
  %inc = add nsw i32 %i.val, 1
  store i32 %inc, i32* %i, align 4
  br label %loop.cond

after.loop:                                       ; preds = %loop.cond
  ; scanf("%d", &start)
  %fmt1 = getelementptr inbounds [3 x i8], [3 x i8]* @.str_one, i64 0, i64 0
  %scan1 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt1, i32* %start)

  ; dijkstra(&s[0][0], n, start)
  %s_begin = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 0, i64 0
  %n.val = load i32, i32* %n, align 4
  %start.val = load i32, i32* %start, align 4
  call void @dijkstra(i32* %s_begin, i32 %n.val, i32 %start.val)

  ret i32 0
}