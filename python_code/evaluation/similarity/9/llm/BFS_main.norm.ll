; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/9/BFS_main.ll'
source_filename = "bfs_main.ll"
target triple = "x86_64-pc-linux-gnu"

@__stack_chk_guard = external thread_local global i64
@.str_hdr = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str_pair = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str_dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

; Function Attrs: noreturn
declare void @__stack_chk_fail() #0

declare void @bfs(i32* noundef, i64 noundef, i64 noundef, i32* noundef, i64* noundef, i64* noundef)

declare i32 @printf(i8* noundef, ...)

declare i32 @putchar(i32 noundef)

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #1

define i32 @main() local_unnamed_addr {
entry:
  %adj = alloca [49 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %order_len = alloca i64, align 8
  %guard = load i64, i64* @__stack_chk_guard, align 4
  %adj.cast = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(196) %adj.cast, i8 0, i64 196, i1 false)
  %adj.idx1.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %adj.idx1.ptr, align 4
  %adj.idx7.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 7
  store i32 1, i32* %adj.idx7.ptr, align 4
  %adj.idx2.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %adj.idx2.ptr, align 8
  %adj.idx14.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 14
  store i32 1, i32* %adj.idx14.ptr, align 8
  %adj.idx10.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 10
  store i32 1, i32* %adj.idx10.ptr, align 8
  %adj.idx22.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 22
  store i32 1, i32* %adj.idx22.ptr, align 8
  %adj.idx11.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 11
  store i32 1, i32* %adj.idx11.ptr, align 4
  %adj.idx29.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 29
  store i32 1, i32* %adj.idx29.ptr, align 4
  %adj.idx19.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 19
  store i32 1, i32* %adj.idx19.ptr, align 4
  %adj.idx37.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 37
  store i32 1, i32* %adj.idx37.ptr, align 4
  %adj.idx33.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 33
  store i32 1, i32* %adj.idx33.ptr, align 4
  %adj.idx39.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 39
  store i32 1, i32* %adj.idx39.ptr, align 4
  %adj.idx41.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 41
  store i32 1, i32* %adj.idx41.ptr, align 4
  %adj.idx47.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 47
  store i32 1, i32* %adj.idx47.ptr, align 4
  store i64 0, i64* %order_len, align 8
  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %dist.base = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %order.base = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  call void @bfs(i32* nonnull %adj.base, i64 7, i64 0, i32* nonnull %dist.base, i64* nonnull %order.base, i64* nonnull %order_len)
  %call_hdr = call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([21 x i8], [21 x i8]* @.str_hdr, i64 0, i64 0), i64 0)
  br label %loop_order

loop_order:                                       ; preds = %loop_body, %entry
  %i.cur = phi i64 [ 0, %entry ], [ %i.plus1, %loop_body ]
  %len.cur = load i64, i64* %order_len, align 8
  %cond.cont = icmp ult i64 %i.cur, %len.cur
  br i1 %cond.cont, label %loop_body, label %after_order

loop_body:                                        ; preds = %loop_order
  %i.plus1 = add i64 %i.cur, 1
  %has_more = icmp ult i64 %i.plus1, %len.cur
  %delim.ptr = select i1 %has_more, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str_space, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0)
  %ord.elem.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %i.cur
  %ord.val = load i64, i64* %ord.elem.ptr, align 8
  %call_pair = call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([6 x i8], [6 x i8]* @.str_pair, i64 0, i64 0), i64 %ord.val, i8* %delim.ptr)
  br label %loop_order

after_order:                                      ; preds = %loop_order
  %nl = call i32 @putchar(i32 10)
  br label %loop_dist

loop_dist:                                        ; preds = %dist_body, %after_order
  %v.cur = phi i64 [ 0, %after_order ], [ %v.next, %dist_body ]
  %cont.dist = icmp ult i64 %v.cur, 7
  br i1 %cont.dist, label %dist_body, label %epilogue

dist_body:                                        ; preds = %loop_dist
  %dist.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %v.cur
  %dval = load i32, i32* %dist.ptr, align 4
  %call_dist = call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([23 x i8], [23 x i8]* @.str_dist, i64 0, i64 0), i64 0, i64 %v.cur, i32 %dval)
  %v.next = add i64 %v.cur, 1
  br label %loop_dist

epilogue:                                         ; preds = %loop_dist
  %guard.now = load i64, i64* @__stack_chk_guard, align 4
  %guard.ok = icmp eq i64 %guard, %guard.now
  br i1 %guard.ok, label %ret, label %stack_fail

stack_fail:                                       ; preds = %epilogue
  call void @__stack_chk_fail()
  unreachable

ret:                                              ; preds = %epilogue
  ret i32 0
}

attributes #0 = { noreturn }
attributes #1 = { argmemonly nofree nounwind willreturn writeonly }
