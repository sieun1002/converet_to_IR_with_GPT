; ModuleID = 'recovered'
source_filename = "recovered"
target triple = "x86_64-pc-linux-gnu"

@.str.two = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.str.three = private unnamed_addr constant [10 x i8] c"%d %d %d\00", align 1
@.str.one = private unnamed_addr constant [3 x i8] c"%d\00", align 1

declare i32 @__isoc99_scanf(i8*, ...)
declare i8* @memset(i8*, i32, i64)
declare void @dijkstra(i32*, i32, i32)

define i32 @main() {
entry:
  %dummy = alloca i32, align 4
  %n = alloca i32, align 4
  %m = alloca i32, align 4
  %s = alloca [100 x [100 x i32]], align 16
  %i = alloca i32, align 4
  %u = alloca i32, align 4
  %v = alloca i32, align 4
  %w = alloca i32, align 4
  %src = alloca i32, align 4

  store i32 0, i32* %dummy, align 4

  %fmt2 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.two, i64 0, i64 0
  %call0 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt2, i32* %n, i32* %m)

  %sptr = bitcast [100 x [100 x i32]]* %s to i8*
  %call1 = call i8* @memset(i8* %sptr, i32 0, i64 40000)

  store i32 0, i32* %i, align 4
  br label %loop

loop:
  %i_val = load i32, i32* %i, align 4
  %m_val = load i32, i32* %m, align 4
  %cond = icmp slt i32 %i_val, %m_val
  br i1 %cond, label %body, label %after

body:
  %fmt3 = getelementptr inbounds [10 x i8], [10 x i8]* @.str.three, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt3, i32* %u, i32* %v, i32* %w)

  %u_load = load i32, i32* %u, align 4
  %v_load = load i32, i32* %v, align 4
  %w_load = load i32, i32* %w, align 4

  %u_i64 = sext i32 %u_load to i64
  %v_i64 = sext i32 %v_load to i64

  %ptr_uv = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %u_i64, i64 %v_i64
  store i32 %w_load, i32* %ptr_uv, align 4

  %ptr_vu = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %v_i64, i64 %u_i64
  store i32 %w_load, i32* %ptr_vu, align 4

  %i_next = add nsw i32 %i_val, 1
  store i32 %i_next, i32* %i, align 4
  br label %loop

after:
  %fmt1 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.one, i64 0, i64 0
  %call3 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt1, i32* %src)

  %base = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 0, i64 0
  %n_val = load i32, i32* %n, align 4
  %src_val = load i32, i32* %src, align 4
  call void @dijkstra(i32* %base, i32 %n_val, i32 %src_val)

  ret i32 0
}