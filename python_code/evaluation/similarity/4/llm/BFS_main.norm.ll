; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/4/BFS_main.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/4/BFS_main.ll"
target triple = "x86_64-pc-linux-gnu"

@.str_bfs = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str_zu_s = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str_dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare void @bfs(i32* nocapture, i64, i64, i32* nocapture, i64* nocapture, i64* nocapture)

declare i32 @printf(i8*, ...)

declare i32 @putchar(i32)

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #0

define dso_local i32 @main() {
entry:
  %adj = alloca [49 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %order_len = alloca i64, align 8
  %adj_i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(196) %adj_i8, i8 0, i64 196, i1 false)
  store i64 0, i64* %order_len, align 8
  %adj_base_ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %adj_base_ptr, align 4
  %adj_0_2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %adj_0_2, align 8
  %adj_1_0 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 7
  store i32 1, i32* %adj_1_0, align 4
  %adj_1_3 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 10
  store i32 1, i32* %adj_1_3, align 8
  %adj_1_4 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 11
  store i32 1, i32* %adj_1_4, align 4
  %adj_2_0 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 14
  store i32 1, i32* %adj_2_0, align 8
  %adj_2_5 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 19
  store i32 1, i32* %adj_2_5, align 4
  %adj_3_1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 22
  store i32 1, i32* %adj_3_1, align 8
  %adj_4_1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 29
  store i32 1, i32* %adj_4_1, align 4
  %adj_4_5 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 33
  store i32 1, i32* %adj_4_5, align 4
  %adj_5_2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 37
  store i32 1, i32* %adj_5_2, align 4
  %adj_5_4 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 39
  store i32 1, i32* %adj_5_4, align 4
  %adj_5_6 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 41
  store i32 1, i32* %adj_5_6, align 4
  %adj_6_5 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 47
  store i32 1, i32* %adj_6_5, align 4
  %adj_ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %dist_ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %order_ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  call void @bfs(i32* nonnull %adj_ptr, i64 7, i64 0, i32* nonnull %dist_ptr, i64* nonnull %order_ptr, i64* nonnull %order_len)
  %call_printf_hdr = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([21 x i8], [21 x i8]* @.str_bfs, i64 0, i64 0), i64 0)
  %len_cur.pre = load i64, i64* %order_len, align 8
  br label %order_loop_cond

order_loop_cond:                                  ; preds = %order_loop_body, %entry
  %i.0 = phi i64 [ 0, %entry ], [ %i_plus1, %order_loop_body ]
  %cmp_i_len = icmp ult i64 %i.0, %len_cur.pre
  br i1 %cmp_i_len, label %order_loop_body, label %order_loop_end

order_loop_body:                                  ; preds = %order_loop_cond
  %i_plus1 = add i64 %i.0, 1
  %cmp_next = icmp ult i64 %i_plus1, %len_cur.pre
  %. = select i1 %cmp_next, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str_space, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0)
  %elem_ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %i.0
  %elem_val = load i64, i64* %elem_ptr, align 8
  %call_printf_item = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([6 x i8], [6 x i8]* @.str_zu_s, i64 0, i64 0), i64 %elem_val, i8* %.)
  br label %order_loop_cond

order_loop_end:                                   ; preds = %order_loop_cond
  %newline = call i32 @putchar(i32 10)
  br label %dist_loop_cond

dist_loop_cond:                                   ; preds = %dist_loop_body, %order_loop_end
  %v.0 = phi i64 [ 0, %order_loop_end ], [ %v_next, %dist_loop_body ]
  %cmp_v_n = icmp ult i64 %v.0, 7
  br i1 %cmp_v_n, label %dist_loop_body, label %dist_loop_end

dist_loop_body:                                   ; preds = %dist_loop_cond
  %dist_ptr_v = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %v.0
  %dist_val = load i32, i32* %dist_ptr_v, align 4
  %call_printf_dist = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([23 x i8], [23 x i8]* @.str_dist, i64 0, i64 0), i64 0, i64 %v.0, i32 %dist_val)
  %v_next = add i64 %v.0, 1
  br label %dist_loop_cond

dist_loop_end:                                    ; preds = %dist_loop_cond
  ret i32 0
}

attributes #0 = { argmemonly nofree nounwind willreturn writeonly }
