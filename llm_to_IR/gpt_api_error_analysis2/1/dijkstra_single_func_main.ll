; ModuleID = 'main_module'
target triple = "x86_64-pc-linux-gnu"

@.str.dd = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.str.ddd = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1
@.str.d = private unnamed_addr constant [3 x i8] c"%d\00", align 1

declare i32 @__isoc99_scanf(i8*, ...)
declare i8* @memset(i8*, i32, i64)
declare void @dijkstra(i32*, i32, i32)

define i32 @main() {
entry:
  %N = alloca i32, align 4
  %M = alloca i32, align 4
  %u = alloca i32, align 4
  %v = alloca i32, align 4
  %w = alloca i32, align 4
  %src = alloca i32, align 4
  %i = alloca i32, align 4
  %s = alloca [100 x [100 x i32]], align 16

  %fmt_dd_ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str.dd, i64 0, i64 0
  %call_scanf1 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt_dd_ptr, i32* %N, i32* %M)

  %s_as_i8 = bitcast [100 x [100 x i32]]* %s to i8*
  %call_memset = call i8* @memset(i8* %s_as_i8, i32 0, i64 40000)

  store i32 0, i32* %i, align 4
  br label %loop.cond

loop.cond:
  %i.val = load i32, i32* %i, align 4
  %M.val = load i32, i32* %M, align 4
  %cmp = icmp slt i32 %i.val, %M.val
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:
  %fmt_ddd_ptr = getelementptr inbounds [9 x i8], [9 x i8]* @.str.ddd, i64 0, i64 0
  %call_scanf2 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt_ddd_ptr, i32* %u, i32* %v, i32* %w)

  %u.val = load i32, i32* %u, align 4
  %v.val = load i32, i32* %v, align 4
  %w.val = load i32, i32* %w, align 4

  %u.idx = sext i32 %u.val to i64
  %v.idx = sext i32 %v.val to i64

  %row.u.ptr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %u.idx
  %cell.uv.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %row.u.ptr, i64 0, i64 %v.idx
  store i32 %w.val, i32* %cell.uv.ptr, align 4

  %row.v.ptr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %v.idx
  %cell.vu.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %row.v.ptr, i64 0, i64 %u.idx
  store i32 %w.val, i32* %cell.vu.ptr, align 4

  %i.next = add nsw i32 %i.val, 1
  store i32 %i.next, i32* %i, align 4
  br label %loop.cond

after.loop:
  %fmt_d_ptr = getelementptr inbounds [3 x i8], [3 x i8]* @.str.d, i64 0, i64 0
  %call_scanf3 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt_d_ptr, i32* %src)

  %base.ptr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 0, i64 0
  %N.pass = load i32, i32* %N, align 4
  %src.pass = load i32, i32* %src, align 4
  call void @dijkstra(i32* %base.ptr, i32 %N.pass, i32 %src.pass)

  ret i32 0
}