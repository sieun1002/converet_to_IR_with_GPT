; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/7/BFS_main.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/7/BFS_main.ll"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str.header = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str.pzs = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare void @bfs(i32*, i64, i64, i32*, i64*, i64*)

declare i32 @printf(i8*, ...)

declare i32 @putchar(i32)

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
  %p1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %p2, align 8
  %p7 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 7
  store i32 1, i32* %p7, align 4
  %p10 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 10
  store i32 1, i32* %p10, align 8
  %p11 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 11
  store i32 1, i32* %p11, align 4
  %p14 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 14
  store i32 1, i32* %p14, align 8
  %p19 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 19
  store i32 1, i32* %p19, align 4
  %p22 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 22
  store i32 1, i32* %p22, align 8
  %p29 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 29
  store i32 1, i32* %p29, align 4
  %p33 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 33
  store i32 1, i32* %p33, align 4
  %p37 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 37
  store i32 1, i32* %p37, align 4
  %p39 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 39
  store i32 1, i32* %p39, align 4
  %p41 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 41
  store i32 1, i32* %p41, align 4
  %p47 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 47
  store i32 1, i32* %p47, align 4
  store i64 0, i64* %order_len, align 8
  %adj.elem = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %dist.elem = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %order.elem = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  call void @bfs(i32* nonnull %adj.elem, i64 7, i64 0, i32* nonnull %dist.elem, i64* nonnull %order.elem, i64* nonnull %order_len)
  %print1 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([21 x i8], [21 x i8]* @.str.header, i64 0, i64 0), i64 0)
  br label %loop1.cond

loop1.cond:                                       ; preds = %loop1.body, %entry
  %i.0 = phi i64 [ 0, %entry ], [ %next, %loop1.body ]
  %len.val = load i64, i64* %order_len, align 8
  %cmp1 = icmp ult i64 %i.0, %len.val
  br i1 %cmp1, label %loop1.body, label %loop1.end

loop1.body:                                       ; preds = %loop1.cond
  %next = add i64 %i.0, 1
  %cond.space = icmp ult i64 %next, %len.val
  %sep = select i1 %cond.space, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.space, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0)
  %order.idx.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %i.0
  %order.val = load i64, i64* %order.idx.ptr, align 8
  %print2 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([6 x i8], [6 x i8]* @.str.pzs, i64 0, i64 0), i64 %order.val, i8* %sep)
  br label %loop1.cond

loop1.end:                                        ; preds = %loop1.cond
  %nl = call i32 @putchar(i32 10)
  br label %loop2.cond

loop2.cond:                                       ; preds = %loop2.body, %loop1.end
  %j.0 = phi i64 [ 0, %loop1.end ], [ %j.next, %loop2.body ]
  %cmp2 = icmp ult i64 %j.0, 7
  br i1 %cmp2, label %loop2.body, label %ret

loop2.body:                                       ; preds = %loop2.cond
  %dist.idx.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %j.0
  %dist.val = load i32, i32* %dist.idx.ptr, align 4
  %print3 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([23 x i8], [23 x i8]* @.str.dist, i64 0, i64 0), i64 0, i64 %j.0, i32 %dist.val)
  %j.next = add i64 %j.0, 1
  br label %loop2.cond

ret:                                              ; preds = %loop2.cond
  ret i32 0
}

attributes #0 = { argmemonly nofree nounwind willreturn writeonly }
