; ModuleID = 'main.ll'
target triple = "x86_64-pc-linux-gnu"

@.str2 = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.str3 = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1
@.str1 = private unnamed_addr constant [3 x i8] c"%d\00", align 1

declare i32 @__isoc99_scanf(i8*, ...)
declare i8* @memset(i8*, i32, i64)
declare void @dijkstra(i32*, i32, i32)

define i32 @main() {
entry:
  %var_4 = alloca i32, align 4
  %var_8 = alloca i32, align 4
  %var_C = alloca i32, align 4
  %var_9C54 = alloca i32, align 4
  %var_9C58 = alloca i32, align 4
  %var_9C5C = alloca i32, align 4
  %var_9C60 = alloca i32, align 4
  %var_9C64 = alloca i32, align 4
  %s = alloca [100 x [100 x i32]], align 16
  store i32 0, i32* %var_4, align 4
  %fmt2.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str2, i64 0, i64 0
  %scan1 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt2.ptr, i32* %var_8, i32* %var_C)
  %s.i8 = bitcast [100 x [100 x i32]]* %s to i8*
  %mem = call i8* @memset(i8* %s.i8, i32 0, i64 40000)
  store i32 0, i32* %var_9C54, align 4
  br label %loop.cond

loop.cond:
  %iv = phi i32 [ 0, %entry ], [ %iv.next, %loop.body ]
  %m.load = load i32, i32* %var_C, align 4
  %cmp = icmp slt i32 %iv, %m.load
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:
  %fmt3.ptr = getelementptr inbounds [9 x i8], [9 x i8]* @.str3, i64 0, i64 0
  %scan3 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt3.ptr, i32* %var_9C58, i32* %var_9C5C, i32* %var_9C60)
  %a.load = load i32, i32* %var_9C58, align 4
  %a.idx = sext i32 %a.load to i64
  %b.load = load i32, i32* %var_9C5C, align 4
  %b.idx = sext i32 %b.load to i64
  %w.load = load i32, i32* %var_9C60, align 4
  %rowptr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %a.idx
  %eltptr = getelementptr inbounds [100 x i32], [100 x i32]* %rowptr, i64 0, i64 %b.idx
  store i32 %w.load, i32* %eltptr, align 4
  %rowptr2 = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %b.idx
  %eltptr2 = getelementptr inbounds [100 x i32], [100 x i32]* %rowptr2, i64 0, i64 %a.idx
  store i32 %w.load, i32* %eltptr2, align 4
  %iv.next = add nsw i32 %iv, 1
  br label %loop.cond

after.loop:
  %fmt1.ptr = getelementptr inbounds [3 x i8], [3 x i8]* @.str1, i64 0, i64 0
  %scan2 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt1.ptr, i32* %var_9C64)
  %baseptr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 0, i64 0
  %n.load = load i32, i32* %var_8, align 4
  %start.load = load i32, i32* %var_9C64, align 4
  call void @dijkstra(i32* %baseptr, i32 %n.load, i32 %start.load)
  ret i32 0
}