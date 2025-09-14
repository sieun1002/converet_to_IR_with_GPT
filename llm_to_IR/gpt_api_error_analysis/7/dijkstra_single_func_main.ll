; ModuleID = 'reconstructed'
target triple = "x86_64-pc-linux-gnu"

@.str2 = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.str3 = private unnamed_addr constant [8 x i8] c"%d %d %d\00", align 1
@.str1 = private unnamed_addr constant [3 x i8] c"%d\00", align 1

declare i32 @__isoc99_scanf(i8*, ...)
declare i8* @memset(i8*, i32, i64)
declare void @dijkstra(i32*, i32, i32)

define i32 @main() local_unnamed_addr {
entry:
  %var8 = alloca i32, align 4
  %varC = alloca i32, align 4
  %varStart = alloca i32, align 4
  %a = alloca i32, align 4
  %b = alloca i32, align 4
  %w = alloca i32, align 4
  %i = alloca i32, align 4
  %s = alloca [100 x [100 x i32]], align 16

  %fmt2.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str2, i64 0, i64 0
  %call.scanf2 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt2.ptr, i32* %var8, i32* %varC)

  %s.i8 = bitcast [100 x [100 x i32]]* %s to i8*
  %memset.call = call i8* @memset(i8* %s.i8, i32 0, i64 40000)

  store i32 0, i32* %i, align 4
  br label %loop

loop:
  %iv = load i32, i32* %i, align 4
  %mval = load i32, i32* %varC, align 4
  %cmp = icmp slt i32 %iv, %mval
  br i1 %cmp, label %body, label %after

body:
  %fmt3.ptr = getelementptr inbounds [8 x i8], [8 x i8]* @.str3, i64 0, i64 0
  %call.scanf3 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt3.ptr, i32* %a, i32* %b, i32* %w)

  %w.val = load i32, i32* %w, align 4
  %a.val = load i32, i32* %a, align 4
  %b.val = load i32, i32* %b, align 4

  %a.idx = sext i32 %a.val to i64
  %b.idx = sext i32 %b.val to i64

  %rowA.ptr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %a.idx
  %elemA.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %rowA.ptr, i64 0, i64 %b.idx
  store i32 %w.val, i32* %elemA.ptr, align 4

  %rowB.ptr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %b.idx
  %elemB.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %rowB.ptr, i64 0, i64 %a.idx
  store i32 %w.val, i32* %elemB.ptr, align 4

  %iv.next = add i32 %iv, 1
  store i32 %iv.next, i32* %i, align 4
  br label %loop

after:
  %fmt1.ptr = getelementptr inbounds [3 x i8], [3 x i8]* @.str1, i64 0, i64 0
  %call.scanf1 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt1.ptr, i32* %varStart)

  %base.ptr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 0, i64 0
  %n.load = load i32, i32* %var8, align 4
  %start.load = load i32, i32* %varStart, align 4
  call void @dijkstra(i32* %base.ptr, i32 %n.load, i32 %start.load)

  ret i32 0
}