; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/10/dijkstra_modular_function6.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/10/dijkstra_modular_function6.ll"
target triple = "x86_64-pc-linux-gnu"

@.str.inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00", align 1
@.str.val = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00", align 1

declare i32 @printf(i8*, ...)

define void @print_distances(i32* %dist, i32 %n) {
entry:
  br label %loop.cond

loop.cond:                                        ; preds = %loop.latch, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.latch ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %loop.body, label %exit

loop.body:                                        ; preds = %loop.cond
  %i.ext = zext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %dist, i64 %i.ext
  %val = load i32, i32* %elem.ptr, align 4
  %isinf = icmp eq i32 %val, 2147483647
  br i1 %isinf, label %if.inf, label %if.val

if.inf:                                           ; preds = %loop.body
  %call.inf = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([16 x i8], [16 x i8]* @.str.inf, i64 0, i64 0), i32 %i)
  br label %loop.latch

if.val:                                           ; preds = %loop.body
  %call.val = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([15 x i8], [15 x i8]* @.str.val, i64 0, i64 0), i32 %i, i32 %val)
  br label %loop.latch

loop.latch:                                       ; preds = %if.val, %if.inf
  %i.next = add nuw nsw i32 %i, 1
  br label %loop.cond

exit:                                             ; preds = %loop.cond
  ret void
}
