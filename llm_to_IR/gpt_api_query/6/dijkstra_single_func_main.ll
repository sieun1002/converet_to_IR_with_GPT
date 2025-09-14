; ModuleID = 'recovered'
source_filename = "recovered.c"

@.str_int = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str_int2 = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.str_int3 = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1

declare i32 @__isoc99_scanf(i8*, ...)
declare i8* @memset(i8*, i32, i64)
declare void @dijkstra([100 x i32]*, i32, i32)

define i32 @main() {
entry:
  %ret = alloca i32, align 4
  %n = alloca i32, align 4
  %m = alloca i32, align 4
  %u = alloca i32, align 4
  %v = alloca i32, align 4
  %w = alloca i32, align 4
  %i = alloca i32, align 4
  %src = alloca i32, align 4
  %s = alloca [100 x [100 x i32]], align 16

  store i32 0, i32* %ret, align 4

  %fmt2 = getelementptr inbounds [6 x i8], [6 x i8]* @.str_int2, i64 0, i64 0
  %call_scanf1 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt2, i32* %n, i32* %m)

  %s_i8 = bitcast [100 x [100 x i32]]* %s to i8*
  %memset_res = call i8* @memset(i8* %s_i8, i32 0, i64 40000)

  store i32 0, i32* %i, align 4
  br label %loop

loop:
  %i_val = load i32, i32* %i, align 4
  %m_val = load i32, i32* %m, align 4
  %cmp = icmp slt i32 %i_val, %m_val
  br i1 %cmp, label %loop.body, label %after_loop

loop.body:
  %fmt3 = getelementptr inbounds [9 x i8], [9 x i8]* @.str_int3, i64 0, i64 0
  %call_scanf2 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt3, i32* %u, i32* %v, i32* %w)

  %u_val = load i32, i32* %u, align 4
  %v_val = load i32, i32* %v, align 4
  %w_val = load i32, i32* %w, align 4
  %u_i64 = sext i32 %u_val to i64
  %v_i64 = sext i32 %v_val to i64

  %row_ptr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %u_i64
  %elem_ptr = getelementptr inbounds [100 x i32], [100 x i32]* %row_ptr, i64 0, i64 %v_i64
  store i32 %w_val, i32* %elem_ptr, align 4

  %row_ptr2 = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %v_i64
  %elem_ptr2 = getelementptr inbounds [100 x i32], [100 x i32]* %row_ptr2, i64 0, i64 %u_i64
  store i32 %w_val, i32* %elem_ptr2, align 4

  %i_next = add nsw i32 %i_val, 1
  store i32 %i_next, i32* %i, align 4
  br label %loop

after_loop:
  %fmt1 = getelementptr inbounds [3 x i8], [3 x i8]* @.str_int, i64 0, i64 0
  %call_scanf3 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt1, i32* %src)

  %row0 = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 0
  %n_val = load i32, i32* %n, align 4
  %src_val = load i32, i32* %src, align 4
  call void @dijkstra([100 x i32]* %row0, i32 %n_val, i32 %src_val)

  ret i32 0
}