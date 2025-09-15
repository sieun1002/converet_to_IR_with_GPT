; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/9/dijkstra_single_func_main.ll'
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
  %var_9C58 = alloca i32, align 4
  %var_9C5C = alloca i32, align 4
  %var_9C60 = alloca i32, align 4
  %var_9C64 = alloca i32, align 4
  %call_scanf_0 = call i32 (i8*, ...) @__isoc99_scanf(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str3, i64 0, i64 3), i32* noundef nonnull %var_8, i32* noundef nonnull %var_C)
  %s_i8 = bitcast [100 x [100 x i32]]* %s to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(40000) %s_i8, i8 noundef 0, i64 noundef 40000, i1 false)
  br label %loop

loop:                                             ; preds = %body, %entry
  %i.0 = phi i32 [ 0, %entry ], [ %inc, %body ]
  %m_val = load i32, i32* %var_C, align 4
  %cmp.not = icmp slt i32 %i.0, %m_val
  br i1 %cmp.not, label %body, label %after_loop

body:                                             ; preds = %loop
  %call_scanf_edges = call i32 (i8*, ...) @__isoc99_scanf(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str3, i64 0, i64 0), i32* noundef nonnull %var_9C58, i32* noundef nonnull %var_9C5C, i32* noundef nonnull %var_9C60)
  %u_val = load i32, i32* %var_9C58, align 4
  %v_val = load i32, i32* %var_9C5C, align 4
  %w_val = load i32, i32* %var_9C60, align 4
  %u64 = sext i32 %u_val to i64
  %v64 = sext i32 %v_val to i64
  %elem_uv = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %u64, i64 %v64
  store i32 %w_val, i32* %elem_uv, align 4
  %elem_vu = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %v64, i64 %u64
  store i32 %w_val, i32* %elem_vu, align 4
  %inc = add nuw nsw i32 %i.0, 1
  br label %loop

after_loop:                                       ; preds = %loop
  %call_scanf_last = call i32 (i8*, ...) @__isoc99_scanf(i8* noundef getelementptr inbounds ([3 x i8], [3 x i8]* @.str1, i64 0, i64 0), i32* noundef nonnull %var_9C64)
  %base_ptr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 0, i64 0
  %src = load i32, i32* %var_8, align 4
  %dst = load i32, i32* %var_9C64, align 4
  call void @dijkstra(i32* noundef nonnull %base_ptr, i32 noundef %src, i32 noundef %dst)
  ret i32 0
}

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #0

attributes #0 = { argmemonly nofree nounwind willreturn writeonly }
