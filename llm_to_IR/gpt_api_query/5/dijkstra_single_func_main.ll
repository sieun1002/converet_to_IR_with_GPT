; ModuleID = 'recovered'
source_filename = "recovered.ll"

@.fmt2i = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.fmt3i = private unnamed_addr constant [10 x i8] c"%d %d %d\00", align 1
@.fmt1i = private unnamed_addr constant [3 x i8] c"%d\00", align 1

declare i32 @__isoc99_scanf(i8*, ...)
declare i8* @memset(i8*, i32, i64)
declare void @dijkstra(i32*, i32, i32)

define i32 @main() {
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

  %p_fmt2i = getelementptr inbounds [6 x i8], [6 x i8]* @.fmt2i, i64 0, i64 0
  %scan0 = call i32 (i8*, ...) @__isoc99_scanf(i8* %p_fmt2i, i32* %var_8, i32* %var_C)

  %s_i8 = bitcast [100 x [100 x i32]]* %s to i8*
  %mem = call i8* @memset(i8* %s_i8, i32 0, i64 40000)

  store i32 0, i32* %var_9C54, align 4
  br label %loop

loop:                                             ; preds = %body, %entry
  %i = load i32, i32* %var_9C54, align 4
  %m = load i32, i32* %var_C, align 4
  %cmp = icmp sge i32 %i, %m
  br i1 %cmp, label %afterloop, label %body

body:                                             ; preds = %loop
  %p_fmt3i = getelementptr inbounds [10 x i8], [10 x i8]* @.fmt3i, i64 0, i64 0
  %scan1 = call i32 (i8*, ...) @__isoc99_scanf(i8* %p_fmt3i, i32* %var_9C58, i32* %var_9C5C, i32* %var_9C60)

  %u = load i32, i32* %var_9C58, align 4
  %v = load i32, i32* %var_9C5C, align 4
  %w = load i32, i32* %var_9C60, align 4

  %u64 = sext i32 %u to i64
  %v64 = sext i32 %v to i64

  ; s[u][v] = w
  %rowptr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %u64
  %elem_uv = getelementptr inbounds [100 x i32], [100 x i32]* %rowptr, i64 0, i64 %v64
  store i32 %w, i32* %elem_uv, align 4

  ; s[v][u] = w
  %rowptr2 = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %v64
  %elem_vu = getelementptr inbounds [100 x i32], [100 x i32]* %rowptr2, i64 0, i64 %u64
  store i32 %w, i32* %elem_vu, align 4

  %i_next = add nsw i32 %i, 1
  store i32 %i_next, i32* %var_9C54, align 4
  br label %loop

afterloop:                                        ; preds = %loop
  %p_fmt1i = getelementptr inbounds [3 x i8], [3 x i8]* @.fmt1i, i64 0, i64 0
  %scan2 = call i32 (i8*, ...) @__isoc99_scanf(i8* %p_fmt1i, i32* %var_9C64)

  %nval = load i32, i32* %var_8, align 4
  %start = load i32, i32* %var_9C64, align 4

  %base0 = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 0
  %base1 = getelementptr inbounds [100 x i32], [100 x i32]* %base0, i64 0, i64 0
  call void @dijkstra(i32* %base1, i32 %nval, i32 %start)

  ret i32 0
}