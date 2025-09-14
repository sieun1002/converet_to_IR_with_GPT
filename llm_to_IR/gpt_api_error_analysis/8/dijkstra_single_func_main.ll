; ModuleID = 'recovered'
source_filename = "recovered"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str.dd = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.str.ddd = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1
@.str.d = private unnamed_addr constant [3 x i8] c"%d\00", align 1

declare i32 @__isoc99_scanf(i8*, ...)
declare i8* @memset(i8*, i32, i64)
declare void @dijkstra(i32*, i32, i32)

define i32 @main() {
entry:
  %var4 = alloca i32, align 4
  %var8 = alloca i32, align 4
  %varC = alloca i32, align 4
  %s = alloca [100 x [100 x i32]], align 16
  %counter = alloca i32, align 4
  %v_i = alloca i32, align 4
  %v_j = alloca i32, align 4
  %v_w = alloca i32, align 4
  %last = alloca i32, align 4
  store i32 0, i32* %var4, align 4
  %fmt1 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.dd, i64 0, i64 0
  %call0 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt1, i32* %var8, i32* %varC)
  %s.i8 = bitcast [100 x [100 x i32]]* %s to i8*
  %call1 = call i8* @memset(i8* %s.i8, i32 0, i64 40000)
  store i32 0, i32* %counter, align 4
  br label %loop.cond

loop.cond:
  %t = load i32, i32* %counter, align 4
  %e = load i32, i32* %varC, align 4
  %cmp = icmp sge i32 %t, %e
  br i1 %cmp, label %after.loop, label %loop.body

loop.body:
  %fmt2 = getelementptr inbounds [9 x i8], [9 x i8]* @.str.ddd, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt2, i32* %v_i, i32* %v_j, i32* %v_w)
  %i = load i32, i32* %v_i, align 4
  %j = load i32, i32* %v_j, align 4
  %w = load i32, i32* %v_w, align 4
  %i64_i = sext i32 %i to i64
  %i64_j = sext i32 %j to i64
  %rowptr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %i64_i
  %eltptr = getelementptr inbounds [100 x i32], [100 x i32]* %rowptr, i64 0, i64 %i64_j
  store i32 %w, i32* %eltptr, align 4
  %rowptr2 = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %i64_j
  %eltptr2 = getelementptr inbounds [100 x i32], [100 x i32]* %rowptr2, i64 0, i64 %i64_i
  store i32 %w, i32* %eltptr2, align 4
  %t2 = load i32, i32* %counter, align 4
  %tinc = add nsw i32 %t2, 1
  store i32 %tinc, i32* %counter, align 4
  br label %loop.cond

after.loop:
  %fmt3 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.d, i64 0, i64 0
  %call3 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt3, i32* %last)
  %sflat = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 0, i64 0
  %n = load i32, i32* %var8, align 4
  %src = load i32, i32* %last, align 4
  call void @dijkstra(i32* %sflat, i32 %n, i32 %src)
  ret i32 0
}