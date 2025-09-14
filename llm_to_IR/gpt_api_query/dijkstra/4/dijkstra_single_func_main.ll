; ModuleID = 'recovered'
source_filename = "recovered.c"

@.str2 = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.str3 = private unnamed_addr constant [10 x i8] c"%d %d %d\00", align 1
@.str1 = private unnamed_addr constant [3 x i8] c"%d\00", align 1

declare i32 @__isoc99_scanf(i8*, ...) local_unnamed_addr
declare i8* @memset(i8*, i32, i64) local_unnamed_addr
declare void @dijkstra(i32*, i32, i32) local_unnamed_addr

define i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %s = alloca [100 x [100 x i32]], align 16
  %n = alloca i32, align 4
  %m = alloca i32, align 4
  %u = alloca i32, align 4
  %v = alloca i32, align 4
  %w = alloca i32, align 4
  %src = alloca i32, align 4
  %i = alloca i32, align 4

  %call0 = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str2, i64 0, i64 0), i32* %n, i32* %m)
  %s.i8 = bitcast [100 x [100 x i32]]* %s to i8*
  %mem = call i8* @memset(i8* %s.i8, i32 0, i64 40000)
  store i32 0, i32* %i, align 4
  br label %loop

loop:
  %i.val = load i32, i32* %i, align 4
  %m.val = load i32, i32* %m, align 4
  %cmp = icmp slt i32 %i.val, %m.val
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:
  %call1 = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str3, i64 0, i64 0), i32* %u, i32* %v, i32* %w)
  %u.val = load i32, i32* %u, align 4
  %v.val = load i32, i32* %v, align 4
  %w.val = load i32, i32* %w, align 4
  %u64 = sext i32 %u.val to i64
  %v64 = sext i32 %v.val to i64
  %rowptr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %u64
  %cellptr = getelementptr inbounds [100 x i32], [100 x i32]* %rowptr, i64 0, i64 %v64
  store i32 %w.val, i32* %cellptr, align 4
  %rowptr2 = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %v64
  %cellptr2 = getelementptr inbounds [100 x i32], [100 x i32]* %rowptr2, i64 0, i64 %u64
  store i32 %w.val, i32* %cellptr2, align 4
  %inc = add nsw i32 %i.val, 1
  store i32 %inc, i32* %i, align 4
  br label %loop

after.loop:
  %call2 = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str1, i64 0, i64 0), i32* %src)
  %n2 = load i32, i32* %n, align 4
  %src2 = load i32, i32* %src, align 4
  %s.base = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 0, i64 0
  call void @dijkstra(i32* %s.base, i32 %n2, i32 %src2)
  ret i32 0
}