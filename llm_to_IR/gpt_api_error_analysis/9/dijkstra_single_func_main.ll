; ModuleID = 'recovered_main'
source_filename = "recovered_main.ll"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str3 = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1
@.str1 = private unnamed_addr constant [3 x i8] c"%d\00", align 1

declare i32 @__isoc99_scanf(i8* noundef, ...) local_unnamed_addr
declare i8* @memset(i8* noundef, i32 noundef, i64 noundef) local_unnamed_addr
declare void @dijkstra(i32* noundef, i32 noundef, i32 noundef) local_unnamed_addr

define dso_local i32 @main() local_unnamed_addr {
entry:
  %var_8 = alloca i32, align 4
  %var_C = alloca i32, align 4
  %s = alloca [100 x [100 x i32]], align 16
  %i = alloca i32, align 4
  %var_9C58 = alloca i32, align 4
  %var_9C5C = alloca i32, align 4
  %var_9C60 = alloca i32, align 4
  %var_9C64 = alloca i32, align 4
  %fmt_ddd_gep3 = getelementptr inbounds [9 x i8], [9 x i8]* @.str3, i64 0, i64 3
  %call_scanf_0 = call i32 (i8*, ...) @__isoc99_scanf(i8* noundef %fmt_ddd_gep3, i32* noundef %var_8, i32* noundef %var_C)
  %s_i8 = bitcast [100 x [100 x i32]]* %s to i8*
  %call_memset = call i8* @memset(i8* noundef %s_i8, i32 noundef 0, i64 noundef 40000)
  store i32 0, i32* %i, align 4
  br label %loop

loop:                                             ; preds = %body, %entry
  %i_val = load i32, i32* %i, align 4
  %m_val = load i32, i32* %var_C, align 4
  %cmp = icmp sge i32 %i_val, %m_val
  br i1 %cmp, label %after_loop, label %body

body:                                             ; preds = %loop
  %fmt_ddd = getelementptr inbounds [9 x i8], [9 x i8]* @.str3, i64 0, i64 0
  %call_scanf_edges = call i32 (i8*, ...) @__isoc99_scanf(i8* noundef %fmt_ddd, i32* noundef %var_9C58, i32* noundef %var_9C5C, i32* noundef %var_9C60)
  %u_val = load i32, i32* %var_9C58, align 4
  %v_val = load i32, i32* %var_9C5C, align 4
  %w_val = load i32, i32* %var_9C60, align 4
  %u64 = sext i32 %u_val to i64
  %v64 = sext i32 %v_val to i64
  %elem_uv = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %u64, i64 %v64
  store i32 %w_val, i32* %elem_uv, align 4
  %elem_vu = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %v64, i64 %u64
  store i32 %w_val, i32* %elem_vu, align 4
  %i_cur = load i32, i32* %i, align 4
  %inc = add nsw i32 %i_cur, 1
  store i32 %inc, i32* %i, align 4
  br label %loop

after_loop:                                       ; preds = %loop
  %fmt_d = getelementptr inbounds [3 x i8], [3 x i8]* @.str1, i64 0, i64 0
  %call_scanf_last = call i32 (i8*, ...) @__isoc99_scanf(i8* noundef %fmt_d, i32* noundef %var_9C64)
  %base_ptr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 0, i64 0
  %src = load i32, i32* %var_8, align 4
  %dst = load i32, i32* %var_9C64, align 4
  call void @dijkstra(i32* noundef %base_ptr, i32 noundef %src, i32 noundef %dst)
  ret i32 0
}