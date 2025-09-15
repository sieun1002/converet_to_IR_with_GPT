; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/4/dijkstra_single_func_main.ll'
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
  %var_8 = alloca i32, align 4
  %var_C = alloca i32, align 4
  %s = alloca [100 x [100 x i32]], align 16
  %var_9C58 = alloca i32, align 4
  %var_9C5C = alloca i32, align 4
  %var_9C60 = alloca i32, align 4
  %var_9C64 = alloca i32, align 4
  %call_scanf_dd = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str_double, i64 0, i64 0), i32* nonnull %var_8, i32* nonnull %var_C)
  %s_as_i8 = bitcast [100 x [100 x i32]]* %s to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(40000) %s_as_i8, i8 0, i64 40000, i1 false)
  br label %loop

loop:                                             ; preds = %body, %entry
  %var_9C54.0 = phi i32 [ 0, %entry ], [ %i_next, %body ]
  %nedges = load i32, i32* %var_C, align 4
  %cmp_ge.not = icmp slt i32 %var_9C54.0, %nedges
  br i1 %cmp_ge.not, label %body, label %after_loop

body:                                             ; preds = %loop
  %call_scanf_ddd = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str_triple, i64 0, i64 0), i32* nonnull %var_9C58, i32* nonnull %var_9C5C, i32* nonnull %var_9C60)
  %w_load_1 = load i32, i32* %var_9C60, align 4
  %u_load = load i32, i32* %var_9C58, align 4
  %v_load = load i32, i32* %var_9C5C, align 4
  %u_idx = sext i32 %u_load to i64
  %v_idx = sext i32 %v_load to i64
  %cell_uv_ptr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %u_idx, i64 %v_idx
  store i32 %w_load_1, i32* %cell_uv_ptr, align 4
  %cell_vu_ptr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %v_idx, i64 %u_idx
  store i32 %w_load_1, i32* %cell_vu_ptr, align 4
  %i_next = add nuw nsw i32 %var_9C54.0, 1
  br label %loop

after_loop:                                       ; preds = %loop
  %call_scanf_d = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str_single, i64 0, i64 0), i32* nonnull %var_9C64)
  %s_flat_ptr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 0, i64 0
  %arg_m = load i32, i32* %var_8, align 4
  %arg_start = load i32, i32* %var_9C64, align 4
  call void @dijkstra(i32* nonnull %s_flat_ptr, i32 %arg_m, i32 %arg_start)
  ret i32 0
}

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #0

attributes #0 = { argmemonly nofree nounwind willreturn writeonly }
