; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/6/dijkstra_single_func_main.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/6/dijkstra_single_func_main.ll"
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
  %s = alloca [100 x [100 x i32]], align 16
  %call_scanf_0 = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str_dd, i64 0, i64 0), i32* nonnull %n, i32* nonnull %m)
  %s_i8 = bitcast [100 x [100 x i32]]* %s to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(40000) %s_i8, i8 0, i64 40000, i1 false)
  br label %loop

loop:                                             ; preds = %body, %entry
  %i.0 = phi i32 [ 0, %entry ], [ %i_next, %body ]
  %m_val = load i32, i32* %m, align 4
  %cmp.not = icmp slt i32 %i.0, %m_val
  br i1 %cmp.not, label %body, label %after_loop

body:                                             ; preds = %loop
  %call_scanf_1 = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str_ddd, i64 0, i64 0), i32* nonnull %x, i32* nonnull %y, i32* nonnull %w)
  %w_val = load i32, i32* %w, align 4
  %x_val = load i32, i32* %x, align 4
  %x_idx = sext i32 %x_val to i64
  %y_val = load i32, i32* %y, align 4
  %y_idx = sext i32 %y_val to i64
  %cell_xy_ptr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %x_idx, i64 %y_idx
  store i32 %w_val, i32* %cell_xy_ptr, align 4
  %cell_yx_ptr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %y_idx, i64 %x_idx
  store i32 %w_val, i32* %cell_yx_ptr, align 4
  %i_next = add nuw nsw i32 %i.0, 1
  br label %loop

after_loop:                                       ; preds = %loop
  %call_scanf_2 = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str_d, i64 0, i64 0), i32* nonnull %k)
  %s_i32_ptr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 0, i64 0
  %n_val = load i32, i32* %n, align 4
  %k_val = load i32, i32* %k, align 4
  call void @dijkstra(i32* nonnull %s_i32_ptr, i32 %n_val, i32 %k_val)
  ret i32 0
}

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #0

attributes #0 = { argmemonly nofree nounwind willreturn writeonly }
