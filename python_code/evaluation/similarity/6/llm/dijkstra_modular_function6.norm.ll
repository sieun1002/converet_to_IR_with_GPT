; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/6/dijkstra_modular_function6.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/6/dijkstra_modular_function6.ll"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str.inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00", align 1
@.str.val = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00", align 1

declare i32 @printf(i8*, ...)

define void @print_distances(i32* %dist, i32 %n) {
entry:
  br label %loop

loop:                                             ; preds = %inc, %entry
  %i.addr.0 = phi i32 [ 0, %entry ], [ %i.next, %inc ]
  %cmp = icmp slt i32 %i.addr.0, %n
  br i1 %cmp, label %body, label %exit

body:                                             ; preds = %loop
  %idx.ext = zext i32 %i.addr.0 to i64
  %elem.ptr = getelementptr inbounds i32, i32* %dist, i64 %idx.ext
  %val = load i32, i32* %elem.ptr, align 4
  %isinf = icmp eq i32 %val, 2147483647
  br i1 %isinf, label %print_inf, label %print_val

print_inf:                                        ; preds = %body
  %call1 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([16 x i8], [16 x i8]* @.str.inf, i64 0, i64 0), i32 %i.addr.0)
  br label %inc

print_val:                                        ; preds = %body
  %call2 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([15 x i8], [15 x i8]* @.str.val, i64 0, i64 0), i32 %i.addr.0, i32 %val)
  br label %inc

inc:                                              ; preds = %print_val, %print_inf
  %i.next = add nuw nsw i32 %i.addr.0, 1
  br label %loop

exit:                                             ; preds = %loop
  ret void
}
