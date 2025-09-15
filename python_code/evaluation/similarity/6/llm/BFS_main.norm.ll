; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/6/BFS_main.ll'
source_filename = "bfs_main.c"
target triple = "x86_64-pc-linux-gnu"

@.str.bfs = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.printpair = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
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
  %out_len = alloca i64, align 8
  store i64 0, i64* %out_len, align 8
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(196) %adj.i8, i8 0, i64 196, i1 false)
  %p.idx1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 7
  store i32 1, i32* %p.idx1, align 4
  %p.idx2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 14
  store i32 1, i32* %p.idx2, align 8
  %p.idx3 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 10
  store i32 1, i32* %p.idx3, align 8
  %p.idx4 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 22
  store i32 1, i32* %p.idx4, align 8
  %p.idx5 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 11
  store i32 1, i32* %p.idx5, align 4
  %p.idx6 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 29
  store i32 1, i32* %p.idx6, align 4
  %p.idx7 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 19
  store i32 1, i32* %p.idx7, align 4
  %p.idx8 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 37
  store i32 1, i32* %p.idx8, align 4
  %p.idx9 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 33
  store i32 1, i32* %p.idx9, align 4
  %p.idx10 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 39
  store i32 1, i32* %p.idx10, align 4
  %p.idx11 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 41
  store i32 1, i32* %p.idx11, align 4
  %p.idx12 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 47
  store i32 1, i32* %p.idx12, align 4
  %dist.base = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %order.base = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  %adj.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  call void @bfs(i32* nonnull %adj.ptr, i64 7, i64 0, i32* nonnull %dist.base, i64* nonnull %order.base, i64* nonnull %out_len)
  %call.print1 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([21 x i8], [21 x i8]* @.str.bfs, i64 0, i64 0), i64 0)
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %i.0 = phi i64 [ 0, %entry ], [ %i.plus1, %loop.body ]
  %olen.val = load i64, i64* %out_len, align 8
  %cmp = icmp ult i64 %i.0, %olen.val
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:                                        ; preds = %loop.cond
  %i.plus1 = add i64 %i.0, 1
  %cmp2 = icmp ult i64 %i.plus1, %olen.val
  %. = select i1 %cmp2, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.space, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0)
  %ord.elem.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %i.0
  %ord.elem = load i64, i64* %ord.elem.ptr, align 8
  %call.printpair = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([6 x i8], [6 x i8]* @.str.printpair, i64 0, i64 0), i64 %ord.elem, i8* %.)
  br label %loop.cond

loop.end:                                         ; preds = %loop.cond
  %nl = call i32 @putchar(i32 10)
  br label %loop2.cond

loop2.cond:                                       ; preds = %loop2.body, %loop.end
  %v.0 = phi i64 [ 0, %loop.end ], [ %v.inc, %loop2.body ]
  %cmp.v = icmp ult i64 %v.0, 7
  br i1 %cmp.v, label %loop2.body, label %exit

loop2.body:                                       ; preds = %loop2.cond
  %dist.elem.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %v.0
  %dist.elem = load i32, i32* %dist.elem.ptr, align 4
  %call.dist = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([23 x i8], [23 x i8]* @.str.dist, i64 0, i64 0), i64 0, i64 %v.0, i32 %dist.elem)
  %v.inc = add i64 %v.0, 1
  br label %loop2.cond

exit:                                             ; preds = %loop2.cond
  ret i32 0
}

attributes #0 = { argmemonly nofree nounwind willreturn writeonly }
