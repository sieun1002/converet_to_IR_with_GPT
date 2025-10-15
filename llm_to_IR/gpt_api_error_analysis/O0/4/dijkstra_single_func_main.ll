; ModuleID = 'recovered_main'
source_filename = "recovered_main.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str_double = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.str_triple = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1
@.str_single = private unnamed_addr constant [3 x i8] c"%d\00", align 1

declare i32 @__isoc99_scanf(i8*, ...)
declare i8* @memset(i8*, i32, i64)
declare void @dijkstra(i32*, i32, i32)

define dso_local i32 @main() {
entry:
  %var_4 = alloca i32, align 4
  %var_8 = alloca i32, align 4
  %var_C = alloca i32, align 4
  %s = alloca [100 x [100 x i32]], align 16
  %var_9C54 = alloca i32, align 4
  %var_9C58 = alloca i32, align 4
  %var_9C5C = alloca i32, align 4
  %var_9C60 = alloca i32, align 4
  %var_9C64 = alloca i32, align 4
  store i32 0, i32* %var_4, align 4
  %fmt_dd_ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str_double, i64 0, i64 0
  %call_scanf_dd = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt_dd_ptr, i32* %var_8, i32* %var_C)
  %s_as_i8 = bitcast [100 x [100 x i32]]* %s to i8*
  %call_memset = call i8* @memset(i8* %s_as_i8, i32 0, i64 40000)
  store i32 0, i32* %var_9C54, align 4
  br label %loop

loop:                                             ; preds = %body, %entry
  %i_val = load i32, i32* %var_9C54, align 4
  %nedges = load i32, i32* %var_C, align 4
  %cmp_ge = icmp sge i32 %i_val, %nedges
  br i1 %cmp_ge, label %after_loop, label %body

body:                                             ; preds = %loop
  %fmt_ddd_ptr = getelementptr inbounds [9 x i8], [9 x i8]* @.str_triple, i64 0, i64 0
  %call_scanf_ddd = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt_ddd_ptr, i32* %var_9C58, i32* %var_9C5C, i32* %var_9C60)
  %w_load_1 = load i32, i32* %var_9C60, align 4
  %u_load = load i32, i32* %var_9C58, align 4
  %v_load = load i32, i32* %var_9C5C, align 4
  %u_idx = sext i32 %u_load to i64
  %v_idx = sext i32 %v_load to i64
  %row_u_ptr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %u_idx
  %cell_uv_ptr = getelementptr inbounds [100 x i32], [100 x i32]* %row_u_ptr, i64 0, i64 %v_idx
  store i32 %w_load_1, i32* %cell_uv_ptr, align 4
  %row_v_ptr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %v_idx
  %cell_vu_ptr = getelementptr inbounds [100 x i32], [100 x i32]* %row_v_ptr, i64 0, i64 %u_idx
  store i32 %w_load_1, i32* %cell_vu_ptr, align 4
  %i_next = add nsw i32 %i_val, 1
  store i32 %i_next, i32* %var_9C54, align 4
  br label %loop

after_loop:                                       ; preds = %loop
  %fmt_d_ptr = getelementptr inbounds [3 x i8], [3 x i8]* @.str_single, i64 0, i64 0
  %call_scanf_d = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt_d_ptr, i32* %var_9C64)
  %s_flat_ptr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 0, i64 0
  %arg_m = load i32, i32* %var_8, align 4
  %arg_start = load i32, i32* %var_9C64, align 4
  call void @dijkstra(i32* %s_flat_ptr, i32 %arg_m, i32 %arg_start)
  ret i32 0
}