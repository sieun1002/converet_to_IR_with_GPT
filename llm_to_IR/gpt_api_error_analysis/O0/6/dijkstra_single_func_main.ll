; ModuleID = 'main_module'
target triple = "x86_64-pc-linux-gnu"

@.str_dd = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.str_ddd = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1
@.str_d = private unnamed_addr constant [3 x i8] c"%d\00", align 1

declare i32 @__isoc99_scanf(i8*, ...)
declare i8* @memset(i8*, i32, i64)
declare void @dijkstra(i32*, i32, i32)

define i32 @main() {
entry:
  %n = alloca i32, align 4
  %m = alloca i32, align 4
  %x = alloca i32, align 4
  %y = alloca i32, align 4
  %w = alloca i32, align 4
  %k = alloca i32, align 4
  %i = alloca i32, align 4
  %s = alloca [100 x [100 x i32]], align 16
  %fmt_dd_ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str_dd, i64 0, i64 0
  %call_scanf_0 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt_dd_ptr, i32* %n, i32* %m)
  %s_i8 = bitcast [100 x [100 x i32]]* %s to i8*
  %memset_call = call i8* @memset(i8* %s_i8, i32 0, i64 40000)
  store i32 0, i32* %i, align 4
  br label %loop

loop:
  %i_val = load i32, i32* %i, align 4
  %m_val = load i32, i32* %m, align 4
  %cmp = icmp sge i32 %i_val, %m_val
  br i1 %cmp, label %after_loop, label %body

body:
  %fmt_ddd_ptr = getelementptr inbounds [9 x i8], [9 x i8]* @.str_ddd, i64 0, i64 0
  %call_scanf_1 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt_ddd_ptr, i32* %x, i32* %y, i32* %w)
  %w_val = load i32, i32* %w, align 4
  %x_val = load i32, i32* %x, align 4
  %x_idx = sext i32 %x_val to i64
  %y_val = load i32, i32* %y, align 4
  %y_idx = sext i32 %y_val to i64
  %row_x_ptr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %x_idx
  %cell_xy_ptr = getelementptr inbounds [100 x i32], [100 x i32]* %row_x_ptr, i64 0, i64 %y_idx
  store i32 %w_val, i32* %cell_xy_ptr, align 4
  %row_y_ptr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %y_idx
  %cell_yx_ptr = getelementptr inbounds [100 x i32], [100 x i32]* %row_y_ptr, i64 0, i64 %x_idx
  store i32 %w_val, i32* %cell_yx_ptr, align 4
  %i_next = add nsw i32 %i_val, 1
  store i32 %i_next, i32* %i, align 4
  br label %loop

after_loop:
  %fmt_d_ptr = getelementptr inbounds [3 x i8], [3 x i8]* @.str_d, i64 0, i64 0
  %call_scanf_2 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt_d_ptr, i32* %k)
  %s_flat_ptr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 0
  %s_i32_ptr = getelementptr inbounds [100 x i32], [100 x i32]* %s_flat_ptr, i64 0, i64 0
  %n_val = load i32, i32* %n, align 4
  %k_val = load i32, i32* %k, align 4
  call void @dijkstra(i32* %s_i32_ptr, i32 %n_val, i32 %k_val)
  ret i32 0
}