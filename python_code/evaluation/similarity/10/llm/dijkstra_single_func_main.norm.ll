; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/10/dijkstra_single_func_main.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/10/dijkstra_single_func_main.ll"
target triple = "x86_64-pc-linux-gnu"

@.str_triple = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1
@.str_double = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.str_single = private unnamed_addr constant [3 x i8] c"%d\00", align 1

declare i32 @__isoc99_scanf(i8*, ...)

declare i8* @memset(i8*, i32, i64)

declare void @dijkstra(i32*, i32, i32)

define i32 @main() local_unnamed_addr {
entry:
  %N = alloca i32, align 4
  %M = alloca i32, align 4
  %s = alloca [10000 x i32], align 16
  %a = alloca i32, align 4
  %b = alloca i32, align 4
  %w = alloca i32, align 4
  %start = alloca i32, align 4
  %call_scanf1 = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str_double, i64 0, i64 0), i32* nonnull %N, i32* nonnull %M)
  %s_i8 = bitcast [10000 x i32]* %s to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(40000) %s_i8, i8 0, i64 40000, i1 false)
  br label %loop

loop:                                             ; preds = %read_edge, %entry
  %i.0 = phi i32 [ 0, %entry ], [ %inc, %read_edge ]
  %M_val = load i32, i32* %M, align 4
  %cmp.not = icmp slt i32 %i.0, %M_val
  br i1 %cmp.not, label %read_edge, label %after_loop

read_edge:                                        ; preds = %loop
  %call_scanf2 = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str_triple, i64 0, i64 0), i32* nonnull %a, i32* nonnull %b, i32* nonnull %w)
  %a_val = load i32, i32* %a, align 4
  %b_val = load i32, i32* %b, align 4
  %w_val = load i32, i32* %w, align 4
  %a_ext = sext i32 %a_val to i64
  %b_ext = sext i32 %b_val to i64
  %row_mul = mul nsw i64 %a_ext, 100
  %idx_ab = add nsw i64 %row_mul, %b_ext
  %elem_ab = getelementptr inbounds [10000 x i32], [10000 x i32]* %s, i64 0, i64 %idx_ab
  store i32 %w_val, i32* %elem_ab, align 4
  %row2_mul = mul nsw i64 %b_ext, 100
  %idx_ba = add nsw i64 %row2_mul, %a_ext
  %elem_ba = getelementptr inbounds [10000 x i32], [10000 x i32]* %s, i64 0, i64 %idx_ba
  store i32 %w_val, i32* %elem_ba, align 4
  %inc = add nuw nsw i32 %i.0, 1
  br label %loop

after_loop:                                       ; preds = %loop
  %call_scanf3 = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str_single, i64 0, i64 0), i32* nonnull %start)
  %s_first = getelementptr inbounds [10000 x i32], [10000 x i32]* %s, i64 0, i64 0
  %N_val2 = load i32, i32* %N, align 4
  %start_val2 = load i32, i32* %start, align 4
  call void @dijkstra(i32* nonnull %s_first, i32 %N_val2, i32 %start_val2)
  ret i32 0
}

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #0

attributes #0 = { argmemonly nofree nounwind willreturn writeonly }
