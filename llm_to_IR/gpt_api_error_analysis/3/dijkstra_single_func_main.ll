; ModuleID = 'recovered'
source_filename = "recovered.ll"
target triple = "x86_64-pc-linux-gnu"

@.str3 = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1
@.str2 = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.str1 = private unnamed_addr constant [3 x i8] c"%d\00", align 1

declare i32 @__isoc99_scanf(i8*, ...)
declare i8* @memset(i8* nocapture, i32, i64)
declare i32 @dijkstra(i32*, i32, i32)

define i32 @main() {
entry:
  %var8 = alloca i32, align 4
  %varC = alloca i32, align 4
  %s = alloca [100 x [100 x i32]], align 16
  %cnt = alloca i32, align 4
  %a = alloca i32, align 4
  %b = alloca i32, align 4
  %w = alloca i32, align 4
  %last = alloca i32, align 4
  %fmt2.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str2, i64 0, i64 0
  %call.scanf1 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt2.ptr, i32* %var8, i32* %varC)
  %s.i8 = bitcast [100 x [100 x i32]]* %s to i8*
  %call.memset = call i8* @memset(i8* %s.i8, i32 0, i64 40000)
  store i32 0, i32* %cnt, align 4
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %i.cur = load i32, i32* %cnt, align 4
  %nedges = load i32, i32* %varC, align 4
  %cmp = icmp slt i32 %i.cur, %nedges
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:                                        ; preds = %loop.cond
  %fmt3.ptr = getelementptr inbounds [9 x i8], [9 x i8]* @.str3, i64 0, i64 0
  %call.scanf2 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt3.ptr, i32* %a, i32* %b, i32* %w)
  %w.val = load i32, i32* %w, align 4
  %a.val = load i32, i32* %a, align 4
  %b.val = load i32, i32* %b, align 4
  %a.idx = sext i32 %a.val to i64
  %b.idx = sext i32 %b.val to i64
  %row.a.ptr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %a.idx
  %elem.ab.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %row.a.ptr, i64 0, i64 %b.idx
  store i32 %w.val, i32* %elem.ab.ptr, align 4
  %row.b.ptr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %b.idx
  %elem.ba.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %row.b.ptr, i64 0, i64 %a.idx
  store i32 %w.val, i32* %elem.ba.ptr, align 4
  %i.next0 = load i32, i32* %cnt, align 4
  %i.inc = add nsw i32 %i.next0, 1
  store i32 %i.inc, i32* %cnt, align 4
  br label %loop.cond

after.loop:                                       ; preds = %loop.cond
  %fmt1.ptr = getelementptr inbounds [3 x i8], [3 x i8]* @.str1, i64 0, i64 0
  %call.scanf3 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt1.ptr, i32* %last)
  %row0.ptr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 0
  %s.flat = getelementptr inbounds [100 x i32], [100 x i32]* %row0.ptr, i64 0, i64 0
  %n.param = load i32, i32* %var8, align 4
  %src.param = load i32, i32* %last, align 4
  %call.dijkstra = call i32 @dijkstra(i32* %s.flat, i32 %n.param, i32 %src.param)
  ret i32 0
}