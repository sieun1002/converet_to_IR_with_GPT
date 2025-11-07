; ModuleID = 'reconstructed_main'
target triple = "x86_64-pc-linux-gnu"

@.str_pair = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.str_triple = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1
@.str_single = private unnamed_addr constant [3 x i8] c"%d\00", align 1

declare i32 @__isoc99_scanf(i8*, ...)
declare i8* @memset(i8*, i32, i64)
declare void @dijkstra(i32*, i32, i32)

define i32 @main() {
entry:
  %n = alloca i32, align 4
  %m = alloca i32, align 4
  %start = alloca i32, align 4
  %i = alloca i32, align 4
  %u = alloca i32, align 4
  %v = alloca i32, align 4
  %w = alloca i32, align 4
  %s = alloca [100 x [100 x i32]], align 16
  %fmt_pair_ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str_pair, i64 0, i64 0
  %call_scanf_pair = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt_pair_ptr, i32* %n, i32* %m)
  %s_i8 = bitcast [100 x [100 x i32]]* %s to i8*
  %call_memset = call i8* @memset(i8* %s_i8, i32 0, i64 40000)
  store i32 0, i32* %i, align 4
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %i.val = load i32, i32* %i, align 4
  %m.val = load i32, i32* %m, align 4
  %cmp = icmp slt i32 %i.val, %m.val
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:                                        ; preds = %loop.cond
  %fmt_triple_ptr = getelementptr inbounds [9 x i8], [9 x i8]* @.str_triple, i64 0, i64 0
  %call_scanf_triple = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt_triple_ptr, i32* %u, i32* %v, i32* %w)
  %u.val = load i32, i32* %u, align 4
  %v.val = load i32, i32* %v, align 4
  %w.val = load i32, i32* %w, align 4
  %u.idx = sext i32 %u.val to i64
  %v.idx = sext i32 %v.val to i64
  %row.ptr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %u.idx
  %elem.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %row.ptr, i64 0, i64 %v.idx
  store i32 %w.val, i32* %elem.ptr, align 4
  %row.ptr.sym = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %v.idx
  %elem.ptr.sym = getelementptr inbounds [100 x i32], [100 x i32]* %row.ptr.sym, i64 0, i64 %u.idx
  store i32 %w.val, i32* %elem.ptr.sym, align 4
  %i.cur = load i32, i32* %i, align 4
  %i.inc = add nsw i32 %i.cur, 1
  store i32 %i.inc, i32* %i, align 4
  br label %loop.cond

after.loop:                                       ; preds = %loop.cond
  %fmt_single_ptr = getelementptr inbounds [3 x i8], [3 x i8]* @.str_single, i64 0, i64 0
  %call_scanf_single = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt_single_ptr, i32* %start)
  %row0 = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 0
  %base = getelementptr inbounds [100 x i32], [100 x i32]* %row0, i64 0, i64 0
  %n.final = load i32, i32* %n, align 4
  %start.final = load i32, i32* %start, align 4
  call void @dijkstra(i32* %base, i32 %n.final, i32 %start.final)
  ret i32 0
}