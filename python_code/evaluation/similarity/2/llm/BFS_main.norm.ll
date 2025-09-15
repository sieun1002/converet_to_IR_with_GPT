; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/2/BFS_main.ll'
source_filename = "bfs_main.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str_bfs = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str_item = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str_dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare dso_local void @bfs(i32* nocapture, i64, i64, i32* nocapture, i64* nocapture, i64* nocapture)

declare dso_local i32 @printf(i8*, ...)

declare dso_local i32 @putchar(i32)

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #0

define dso_local i32 @main() {
entry:
  %adj = alloca [49 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %len = alloca i64, align 8
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(196) %adj.i8, i8 0, i64 196, i1 false)
  store i64 0, i64* %len, align 8
  %adj.idx1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %adj.idx1, align 4
  %adj.idx7 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 7
  store i32 1, i32* %adj.idx7, align 4
  %adj.idx2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %adj.idx2, align 8
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
  %dist.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %order.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  call void @bfs(i32* nonnull %adj.ptr, i64 7, i64 0, i32* nonnull %dist.ptr, i64* nonnull %order.ptr, i64* nonnull %len)
  %call.printf0 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([21 x i8], [21 x i8]* @.str_bfs, i64 0, i64 0), i64 0)
  %len.cur.pre = load i64, i64* %len, align 8
  br label %loop.items

loop.items:                                       ; preds = %body.items, %entry
  %i.0 = phi i64 [ 0, %entry ], [ %i.plus1, %body.items ]
  %cond.items = icmp ult i64 %i.0, %len.cur.pre
  br i1 %cond.items, label %body.items, label %after.items

body.items:                                       ; preds = %loop.items
  %i.plus1 = add i64 %i.0, 1
  %is.last.not = icmp ult i64 %i.plus1, %len.cur.pre
  %sep.ptr = select i1 %is.last.not, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str_space, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0)
  %order.elem.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %i.0
  %order.elem = load i64, i64* %order.elem.ptr, align 8
  %call.printf1 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([6 x i8], [6 x i8]* @.str_item, i64 0, i64 0), i64 %order.elem, i8* %sep.ptr)
  br label %loop.items

after.items:                                      ; preds = %loop.items
  %nl.call = call i32 @putchar(i32 10)
  br label %loop.dist

loop.dist:                                        ; preds = %body.dist, %after.items
  %j.0 = phi i64 [ 0, %after.items ], [ %j.next, %body.dist ]
  %cond.dist = icmp ult i64 %j.0, 7
  br i1 %cond.dist, label %body.dist, label %ret.block

body.dist:                                        ; preds = %loop.dist
  %dist.elem.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %j.0
  %dist.elem = load i32, i32* %dist.elem.ptr, align 4
  %call.printf2 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([23 x i8], [23 x i8]* @.str_dist, i64 0, i64 0), i64 0, i64 %j.0, i32 %dist.elem)
  %j.next = add i64 %j.0, 1
  br label %loop.dist

ret.block:                                        ; preds = %loop.dist
  ret i32 0
}

attributes #0 = { argmemonly nofree nounwind willreturn writeonly }
