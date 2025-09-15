; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/2/DFS_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/2/DFS_function.ll"
target triple = "x86_64-pc-linux-gnu"

@.str_dfs = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str_elem = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1

declare i32 @printf(i8*, ...)

declare i32 @putchar(i32)

declare void @dfs(i32*, i64, i64, i64*, i64*)

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #0

define i32 @main() {
entry:
  %adj = alloca [49 x i32], align 16
  %out = alloca [49 x i64], align 16
  %out_len = alloca i64, align 8
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(196) %adj.i8, i8 0, i64 196, i1 false)
  store i64 0, i64* %out_len, align 8
  %adj.idx1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %adj.idx1, align 4
  %adj.idx2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %adj.idx2, align 8
  %adj.idx7 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 7
  store i32 1, i32* %adj.idx7, align 4
  %adj.idx14 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 14
  store i32 1, i32* %adj.idx14, align 8
  %adj.idx10 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 10
  store i32 1, i32* %adj.idx10, align 8
  %adj.idx22 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 22
  store i32 1, i32* %adj.idx22, align 8
  %adj.idx11 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 11
  store i32 1, i32* %adj.idx11, align 4
  %adj.idx29 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 29
  store i32 1, i32* %adj.idx29, align 4
  %adj.idx19 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 19
  store i32 1, i32* %adj.idx19, align 4
  %adj.idx37 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 37
  store i32 1, i32* %adj.idx37, align 4
  %adj.idx33 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 33
  store i32 1, i32* %adj.idx33, align 4
  %adj.idx39 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 39
  store i32 1, i32* %adj.idx39, align 4
  %adj.idx41 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 41
  store i32 1, i32* %adj.idx41, align 4
  %adj.idx47 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 47
  store i32 1, i32* %adj.idx47, align 4
  %adj.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %out.ptr = getelementptr inbounds [49 x i64], [49 x i64]* %out, i64 0, i64 0
  call void @dfs(i32* nonnull %adj.ptr, i64 7, i64 0, i64* nonnull %out.ptr, i64* nonnull %out_len)
  %call.printf0 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([24 x i8], [24 x i8]* @.str_dfs, i64 0, i64 0), i64 0)
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %i.ph = phi i64 [ 0, %entry ], [ %i.plus1, %loop.body ]
  %len.cur = load i64, i64* %out_len, align 8
  %cmp = icmp ult i64 %i.ph, %len.cur
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:                                        ; preds = %loop.cond
  %i.plus1 = add i64 %i.ph, 1
  %has_space = icmp ult i64 %i.plus1, %len.cur
  %suffix.ptr = select i1 %has_space, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str_space, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0)
  %elem.ptr = getelementptr inbounds [49 x i64], [49 x i64]* %out, i64 0, i64 %i.ph
  %elem.val = load i64, i64* %elem.ptr, align 8
  %call.printf1 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([6 x i8], [6 x i8]* @.str_elem, i64 0, i64 0), i64 %elem.val, i8* %suffix.ptr)
  br label %loop.cond

loop.end:                                         ; preds = %loop.cond
  %nl.call = call i32 @putchar(i32 10)
  ret i32 0
}

attributes #0 = { argmemonly nofree nounwind willreturn writeonly }
