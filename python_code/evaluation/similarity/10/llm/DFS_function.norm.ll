; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/10/DFS_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/10/DFS_function.ll"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str.title = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str.fmt = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1

declare void @dfs(i32* nocapture, i64, i64, i64*, i64*)

declare i32 @printf(i8*, ...)

declare i32 @putchar(i32)

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #0

define i32 @main() {
entry:
  %adj = alloca [49 x i32], align 16
  %out = alloca [7 x i64], align 16
  %out_len = alloca i64, align 8
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(196) %adj.i8, i8 0, i64 196, i1 false)
  %p0 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %p0, align 4
  %p1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 7
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %p2, align 8
  %p3 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 14
  store i32 1, i32* %p3, align 8
  %p4 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 10
  store i32 1, i32* %p4, align 8
  %p5 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 22
  store i32 1, i32* %p5, align 8
  %p6 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 11
  store i32 1, i32* %p6, align 4
  %p7 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 29
  store i32 1, i32* %p7, align 4
  %p8 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 19
  store i32 1, i32* %p8, align 4
  %p9 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 37
  store i32 1, i32* %p9, align 4
  %p10 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 33
  store i32 1, i32* %p10, align 4
  %p11 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 39
  store i32 1, i32* %p11, align 4
  %p12 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 41
  store i32 1, i32* %p12, align 4
  %p13 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 47
  store i32 1, i32* %p13, align 4
  store i64 0, i64* %out_len, align 8
  %adj.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %out.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %out, i64 0, i64 0
  call void @dfs(i32* nonnull %adj.ptr, i64 7, i64 0, i64* nonnull %out.ptr, i64* nonnull %out_len)
  %call.printf1 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([24 x i8], [24 x i8]* @.str.title, i64 0, i64 0), i64 0)
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %i.0 = phi i64 [ 0, %entry ], [ %i.next1, %loop.body ]
  %len.cur = load i64, i64* %out_len, align 8
  %cmp.lt = icmp ult i64 %i.0, %len.cur
  br i1 %cmp.lt, label %loop.body, label %loop.end

loop.body:                                        ; preds = %loop.cond
  %i.next1 = add i64 %i.0, 1
  %cmp.sep = icmp ult i64 %i.next1, %len.cur
  %sep.ptr = select i1 %cmp.sep, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.space, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0)
  %elem.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %out, i64 0, i64 %i.0
  %elem.val = load i64, i64* %elem.ptr, align 8
  %call.printf2 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([6 x i8], [6 x i8]* @.str.fmt, i64 0, i64 0), i64 %elem.val, i8* %sep.ptr)
  br label %loop.cond

loop.end:                                         ; preds = %loop.cond
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}

attributes #0 = { argmemonly nofree nounwind willreturn writeonly }
