; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/3/BFS_main.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/3/BFS_main.ll"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str.bfs = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.zu_s = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
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
  store i64 0, i64* %order_len, align 8
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(196) %adj.i8, i8 0, i64 196, i1 false)
  %adj.idx1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %adj.idx1, align 4
  %adj.idx2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %adj.idx2, align 8
  %adj.idx7 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 7
  store i32 1, i32* %adj.idx7, align 4
  %adj.idx10 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 10
  store i32 1, i32* %adj.idx10, align 8
  %adj.idx11 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 11
  store i32 1, i32* %adj.idx11, align 4
  %adj.idx14 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 14
  store i32 1, i32* %adj.idx14, align 8
  %adj.idx19 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 19
  store i32 1, i32* %adj.idx19, align 4
  %adj.idx22 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 22
  store i32 1, i32* %adj.idx22, align 8
  %adj.idx29 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 29
  store i32 1, i32* %adj.idx29, align 4
  %adj.idx33 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 33
  store i32 1, i32* %adj.idx33, align 4
  %adj.idx37 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 37
  store i32 1, i32* %adj.idx37, align 4
  %adj.idx39 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 39
  store i32 1, i32* %adj.idx39, align 4
  %adj.idx41 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 41
  store i32 1, i32* %adj.idx41, align 4
  %adj.idx47 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 47
  store i32 1, i32* %adj.idx47, align 4
  %adj.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %dist.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %order.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  call void @bfs(i32* nonnull %adj.ptr, i64 7, i64 0, i32* nonnull %dist.ptr, i64* nonnull %order.ptr, i64* nonnull %order_len)
  %call.printf.bfs = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([21 x i8], [21 x i8]* @.str.bfs, i64 0, i64 0), i64 0)
  br label %loop.bfs

loop.bfs:                                         ; preds = %loop.bfs.body, %entry
  %k.0 = phi i64 [ 0, %entry ], [ %k.plus1, %loop.bfs.body ]
  %len.cur = load i64, i64* %order_len, align 8
  %cond = icmp ult i64 %k.0, %len.cur
  br i1 %cond, label %loop.bfs.body, label %loop.bfs.end

loop.bfs.body:                                    ; preds = %loop.bfs
  %k.plus1 = add i64 %k.0, 1
  %sep.need.space = icmp ult i64 %k.plus1, %len.cur
  %sep.ptr = select i1 %sep.need.space, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.space, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0)
  %order.elem.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %k.0
  %order.elem = load i64, i64* %order.elem.ptr, align 8
  %call.printf.seq = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([6 x i8], [6 x i8]* @.str.zu_s, i64 0, i64 0), i64 %order.elem, i8* %sep.ptr)
  br label %loop.bfs

loop.bfs.end:                                     ; preds = %loop.bfs
  %nl = call i32 @putchar(i32 10)
  br label %loop.dist

loop.dist:                                        ; preds = %loop.dist.body, %loop.bfs.end
  %t.0 = phi i64 [ 0, %loop.bfs.end ], [ %t.next, %loop.dist.body ]
  %cond.dist = icmp ult i64 %t.0, 7
  br i1 %cond.dist, label %loop.dist.body, label %end

loop.dist.body:                                   ; preds = %loop.dist
  %dist.elem.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %t.0
  %dist.elem = load i32, i32* %dist.elem.ptr, align 4
  %call.printf.dist = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([23 x i8], [23 x i8]* @.str.dist, i64 0, i64 0), i64 0, i64 %t.0, i32 %dist.elem)
  %t.next = add i64 %t.0, 1
  br label %loop.dist

end:                                              ; preds = %loop.dist
  ret i32 0
}

attributes #0 = { argmemonly nofree nounwind willreturn writeonly }
