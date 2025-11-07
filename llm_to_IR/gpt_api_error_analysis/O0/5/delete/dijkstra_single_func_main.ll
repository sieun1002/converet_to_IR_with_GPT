; ModuleID = 'main_module'
target triple = "x86_64-pc-linux-gnu"

@.str.two = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.str.three = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1
@.str.one = private unnamed_addr constant [3 x i8] c"%d\00", align 1

declare i32 @__isoc99_scanf(i8*, ...)
declare i8* @memset(i8*, i32, i64)
declare void @dijkstra(i32*, i32, i32)

define i32 @main() {
entry:
  %var4 = alloca i32, align 4
  %n = alloca i32, align 4
  %m = alloca i32, align 4
  %s = alloca [10000 x i32], align 16
  %i = alloca i32, align 4
  %u = alloca i32, align 4
  %v = alloca i32, align 4
  %w = alloca i32, align 4
  %src = alloca i32, align 4
  store i32 0, i32* %var4, align 4
  %fmt_two_ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str.two, i64 0, i64 0
  %call_scanf1 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt_two_ptr, i32* %n, i32* %m)
  %s_as_i8 = bitcast [10000 x i32]* %s to i8*
  %call_memset = call i8* @memset(i8* %s_as_i8, i32 0, i64 40000)
  store i32 0, i32* %i, align 4
  br label %loop.cond

loop.cond:
  %i.val = load i32, i32* %i, align 4
  %m.val = load i32, i32* %m, align 4
  %cmp = icmp slt i32 %i.val, %m.val
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:
  %fmt_three_ptr = getelementptr inbounds [9 x i8], [9 x i8]* @.str.three, i64 0, i64 0
  %call_scanf2 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt_three_ptr, i32* %u, i32* %v, i32* %w)
  %w.val = load i32, i32* %w, align 4
  %u.val = load i32, i32* %u, align 4
  %u.ext = sext i32 %u.val to i64
  %mul.row = mul nsw i64 %u.ext, 100
  %v.val = load i32, i32* %v, align 4
  %v.ext = sext i32 %v.val to i64
  %idx.uv = add nsw i64 %mul.row, %v.ext
  %elem.uv.ptr = getelementptr inbounds [10000 x i32], [10000 x i32]* %s, i64 0, i64 %idx.uv
  store i32 %w.val, i32* %elem.uv.ptr, align 4
  %w2.val = load i32, i32* %w, align 4
  %v2.val = load i32, i32* %v, align 4
  %v2.ext = sext i32 %v2.val to i64
  %mul.row.v = mul nsw i64 %v2.ext, 100
  %u2.val = load i32, i32* %u, align 4
  %u2.ext = sext i32 %u2.val to i64
  %idx.vu = add nsw i64 %mul.row.v, %u2.ext
  %elem.vu.ptr = getelementptr inbounds [10000 x i32], [10000 x i32]* %s, i64 0, i64 %idx.vu
  store i32 %w2.val, i32* %elem.vu.ptr, align 4
  %i.next = add nsw i32 %i.val, 1
  store i32 %i.next, i32* %i, align 4
  br label %loop.cond

after.loop:
  %fmt_one_ptr = getelementptr inbounds [3 x i8], [3 x i8]* @.str.one, i64 0, i64 0
  %call_scanf3 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt_one_ptr, i32* %src)
  %s.base = getelementptr inbounds [10000 x i32], [10000 x i32]* %s, i64 0, i64 0
  %n.load = load i32, i32* %n, align 4
  %src.load = load i32, i32* %src, align 4
  call void @dijkstra(i32* %s.base, i32 %n.load, i32 %src.load)
  ret i32 0
}