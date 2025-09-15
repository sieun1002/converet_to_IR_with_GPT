; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/5/DFS_function.ll'
source_filename = "main_module"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str.pre = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.fmt = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1

declare dso_local void @dfs(i32* nocapture, i64, i64, i64* nocapture, i64* nocapture)

declare dso_local i32 @printf(i8*, ...)

declare dso_local i32 @putchar(i32)

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #0

define dso_local i32 @main() {
entry:
  %graph = alloca [48 x i32], align 16
  %order = alloca [64 x i64], align 16
  %len = alloca i64, align 8
  %g0 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 0
  %g0i8 = bitcast [48 x i32]* %graph to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(192) %g0i8, i8 0, i64 192, i1 false)
  store i64 0, i64* %len, align 8
  %p1 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 2
  store i32 1, i32* %p2, align 8
  %p7 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 7
  store i32 1, i32* %p7, align 4
  %p10 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 10
  store i32 1, i32* %p10, align 8
  %p11 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 11
  store i32 1, i32* %p11, align 4
  %p14 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 14
  store i32 1, i32* %p14, align 8
  %p19 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 19
  store i32 1, i32* %p19, align 4
  %p22 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 22
  store i32 1, i32* %p22, align 8
  %p29 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 29
  store i32 1, i32* %p29, align 4
  %p33 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 33
  store i32 1, i32* %p33, align 4
  %p37 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 37
  store i32 1, i32* %p37, align 4
  %p39 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 39
  store i32 1, i32* %p39, align 4
  %p41 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 41
  store i32 1, i32* %p41, align 4
  %p47 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 47
  store i32 1, i32* %p47, align 4
  %ord0 = getelementptr inbounds [64 x i64], [64 x i64]* %order, i64 0, i64 0
  call void @dfs(i32* nonnull %g0, i64 7, i64 0, i64* nonnull %ord0, i64* nonnull %len)
  %call_pre = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([24 x i8], [24 x i8]* @.str.pre, i64 0, i64 0), i64 0)
  %len.cur.pre = load i64, i64* %len, align 8
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %i.0 = phi i64 [ 0, %entry ], [ %next, %loop.body ]
  %cmp = icmp ult i64 %i.0, %len.cur.pre
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:                                        ; preds = %loop.cond
  %next = add i64 %i.0, 1
  %ge.not = icmp ult i64 %next, %len.cur.pre
  %delim = select i1 %ge.not, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.space, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0)
  %val.ptr = getelementptr inbounds [64 x i64], [64 x i64]* %order, i64 0, i64 %i.0
  %val = load i64, i64* %val.ptr, align 8
  %call_item = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([6 x i8], [6 x i8]* @.str.fmt, i64 0, i64 0), i64 %val, i8* %delim)
  br label %loop.cond

loop.end:                                         ; preds = %loop.cond
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}

attributes #0 = { argmemonly nofree nounwind willreturn writeonly }
