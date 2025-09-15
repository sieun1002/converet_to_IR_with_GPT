; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/1/BFS_main.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/1/BFS_main.ll"
target triple = "x86_64-unknown-linux-gnu"

@.str.header = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str.sep = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare i32 @printf(i8*, ...)

declare i32 @putchar(i32)

declare void @bfs(i32* noundef, i64 noundef, i64 noundef, i32* noundef, i64* noundef, i64* noundef)

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #0

define i32 @main() {
entry:
  %adj = alloca [49 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %order_len = alloca i64, align 8
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(196) %adj.i8, i8 0, i64 196, i1 false)
  %gep1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %gep1, align 4
  %gep2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %gep2, align 8
  %gep_n = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 7
  store i32 1, i32* %gep_n, align 4
  %gep_2n = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 14
  store i32 1, i32* %gep_2n, align 8
  %gep_n3 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 10
  store i32 1, i32* %gep_n3, align 8
  %gep_3n1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 22
  store i32 1, i32* %gep_3n1, align 8
  %gep_n4 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 11
  store i32 1, i32* %gep_n4, align 4
  %gep_4n1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 29
  store i32 1, i32* %gep_4n1, align 4
  %gep_2n5 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 19
  store i32 1, i32* %gep_2n5, align 4
  %gep_5n2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 37
  store i32 1, i32* %gep_5n2, align 4
  %gep_4n5 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 33
  store i32 1, i32* %gep_4n5, align 4
  %gep_5n4 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 39
  store i32 1, i32* %gep_5n4, align 4
  %gep_5n6 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 41
  store i32 1, i32* %gep_5n6, align 4
  %gep_6n5 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 47
  store i32 1, i32* %gep_6n5, align 4
  store i64 0, i64* %order_len, align 8
  %adjptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %distptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %orderptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  call void @bfs(i32* nonnull %adjptr, i64 7, i64 0, i32* nonnull %distptr, i64* nonnull %orderptr, i64* nonnull %order_len)
  %call_printf_hdr = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([21 x i8], [21 x i8]* @.str.header, i64 0, i64 0), i64 0)
  br label %print_loop.header

print_loop.header:                                ; preds = %print_loop.body, %entry
  %i_phi = phi i64 [ 0, %entry ], [ %i_plus1, %print_loop.body ]
  %len_cur = load i64, i64* %order_len, align 8
  %cmp_i_len = icmp ult i64 %i_phi, %len_cur
  br i1 %cmp_i_len, label %print_loop.body, label %print_loop.exit

print_loop.body:                                  ; preds = %print_loop.header
  %i_plus1 = add i64 %i_phi, 1
  %has_space = icmp ult i64 %i_plus1, %len_cur
  %sep_ptr = select i1 %has_space, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.space, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0)
  %order_elem_ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %i_phi
  %order_elem = load i64, i64* %order_elem_ptr, align 8
  %call_printf_item = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([6 x i8], [6 x i8]* @.str.sep, i64 0, i64 0), i64 %order_elem, i8* %sep_ptr)
  br label %print_loop.header

print_loop.exit:                                  ; preds = %print_loop.header
  %nl_call = call i32 @putchar(i32 10)
  br label %dist_loop.header

dist_loop.header:                                 ; preds = %dist_loop.body, %print_loop.exit
  %j_phi = phi i64 [ 0, %print_loop.exit ], [ %j_next, %dist_loop.body ]
  %cmp_j_n = icmp ult i64 %j_phi, 7
  br i1 %cmp_j_n, label %dist_loop.body, label %dist_loop.exit

dist_loop.body:                                   ; preds = %dist_loop.header
  %dist_elem_ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %j_phi
  %dist_elem = load i32, i32* %dist_elem_ptr, align 4
  %call_printf_dist = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([23 x i8], [23 x i8]* @.str.dist, i64 0, i64 0), i64 0, i64 %j_phi, i32 %dist_elem)
  %j_next = add i64 %j_phi, 1
  br label %dist_loop.header

dist_loop.exit:                                   ; preds = %dist_loop.header
  ret i32 0
}

attributes #0 = { argmemonly nofree nounwind willreturn writeonly }
