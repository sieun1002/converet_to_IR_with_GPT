; ModuleID = 'recovered'
source_filename = "recovered.c"

@.str_dd = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.str_ddd = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1
@.str_d = private unnamed_addr constant [3 x i8] c"%d\00", align 1

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

  %fmt1 = getelementptr inbounds [6 x i8], [6 x i8]* @.str_dd, i64 0, i64 0
  %call_scanf1 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt1, i32* %var_8, i32* %var_C)

  %s_i8 = bitcast [100 x [100 x i32]]* %s to i8*
  %memset_call = call i8* @memset(i8* %s_i8, i32 0, i64 40000)

  store i32 0, i32* %var_9C54, align 4
  br label %loop

loop:
  %i = load i32, i32* %var_9C54, align 4
  %m = load i32, i32* %var_C, align 4
  %cmp = icmp slt i32 %i, %m
  br i1 %cmp, label %body, label %after_loop

body:
  %fmt2 = getelementptr inbounds [9 x i8], [9 x i8]* @.str_ddd, i64 0, i64 0
  %call_scanf2 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt2, i32* %var_9C58, i32* %var_9C5C, i32* %var_9C60)

  %a = load i32, i32* %var_9C58, align 4
  %b = load i32, i32* %var_9C5C, align 4
  %w = load i32, i32* %var_9C60, align 4

  %a64 = sext i32 %a to i64
  %b64 = sext i32 %b to i64

  %row_a = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %a64
  %cell_ab = getelementptr inbounds [100 x i32], [100 x i32]* %row_a, i64 0, i64 %b64
  store i32 %w, i32* %cell_ab, align 4

  %row_b = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %b64
  %a64b = sext i32 %a to i64
  %cell_ba = getelementptr inbounds [100 x i32], [100 x i32]* %row_b, i64 0, i64 %a64b
  store i32 %w, i32* %cell_ba, align 4

  %i_next = add nsw i32 %i, 1
  store i32 %i_next, i32* %var_9C54, align 4
  br label %loop

after_loop:
  %fmt3 = getelementptr inbounds [3 x i8], [3 x i8]* @.str_d, i64 0, i64 0
  %call_scanf3 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt3, i32* %var_9C64)

  %s_flat = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 0, i64 0
  %n_val = load i32, i32* %var_8, align 4
  %src_val = load i32, i32* %var_9C64, align 4
  call void @dijkstra(i32* %s_flat, i32 %n_val, i32 %src_val)

  ret i32 0
}