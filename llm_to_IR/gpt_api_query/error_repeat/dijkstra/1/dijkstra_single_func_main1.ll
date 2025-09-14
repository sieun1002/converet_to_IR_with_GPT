; ModuleID = 'recovered'
source_filename = "main"

@.str.dd = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.str.ddd = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1
@.str.d = private unnamed_addr constant [3 x i8] c"%d\00", align 1

declare i32 @__isoc99_scanf(i8*, ...)
declare i8* @memset(i8*, i32, i64)
declare void @dijkstra([100 x i32]*, i32, i32)

define i32 @main() {
entry:
  %tmp = alloca i32, align 4
  %n = alloca i32, align 4
  %m = alloca i32, align 4
  %s = alloca [100 x [100 x i32]], align 16
  %i = alloca i32, align 4
  %a = alloca i32, align 4
  %b = alloca i32, align 4
  %w = alloca i32, align 4
  %start = alloca i32, align 4

  store i32 0, i32* %tmp, align 4

  %fmt1ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str.dd, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt1ptr, i32* %n, i32* %m)

  %sbyte = bitcast [100 x [100 x i32]]* %s to i8*
  %mem = call i8* @memset(i8* %sbyte, i32 0, i64 40000)

  store i32 0, i32* %i, align 4
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %i.val = load i32, i32* %i, align 4
  %m.val = load i32, i32* %m, align 4
  %cmp = icmp sge i32 %i.val, %m.val
  br i1 %cmp, label %after.loop, label %loop.body

loop.body:                                        ; preds = %loop.cond
  %fmt2ptr = getelementptr inbounds [9 x i8], [9 x i8]* @.str.ddd, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt2ptr, i32* %a, i32* %b, i32* %w)

  %a32 = load i32, i32* %a, align 4
  %b32 = load i32, i32* %b, align 4
  %w32 = load i32, i32* %w, align 4

  %a64 = sext i32 %a32 to i64
  %b64 = sext i32 %b32 to i64

  %rowA = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %a64
  %cellAB = getelementptr inbounds [100 x i32], [100 x i32]* %rowA, i64 0, i64 %b64
  store i32 %w32, i32* %cellAB, align 4

  %rowB = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %b64
  %cellBA = getelementptr inbounds [100 x i32], [100 x i32]* %rowB, i64 0, i64 %a64
  store i32 %w32, i32* %cellBA, align 4

  %inc = add nsw i32 %i.val, 1
  store i32 %inc, i32* %i, align 4
  br label %loop.cond

after.loop:                                       ; preds = %loop.cond
  %fmt3ptr = getelementptr inbounds [3 x i8], [3 x i8]* @.str.d, i64 0, i64 0
  %call3 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt3ptr, i32* %start)

  %firstrow = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 0
  %nval = load i32, i32* %n, align 4
  %startval = load i32, i32* %start, align 4
  call void @dijkstra([100 x i32]* %firstrow, i32 %nval, i32 %startval)

  ret i32 0
}