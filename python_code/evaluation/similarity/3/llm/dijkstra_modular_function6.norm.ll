; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/3/dijkstra_modular_function6.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/3/dijkstra_modular_function6.ll"
target triple = "x86_64-pc-linux-gnu"

@.str_inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00", align 1
@.str_val = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00", align 1

declare i32 @printf(i8*, ...)

define void @print_distances(i32* %dist, i32 %n) {
entry:
  br label %loop

loop:                                             ; preds = %inc, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %inc ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %body, label %exit

body:                                             ; preds = %loop
  %idx.ext = zext i32 %i to i64
  %ptr = getelementptr inbounds i32, i32* %dist, i64 %idx.ext
  %val = load i32, i32* %ptr, align 4
  %isinf = icmp eq i32 %val, 2147483647
  br i1 %isinf, label %print_inf, label %print_val

print_inf:                                        ; preds = %body
  %call1 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([16 x i8], [16 x i8]* @.str_inf, i64 0, i64 0), i32 %i)
  br label %inc

print_val:                                        ; preds = %body
  %call2 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([15 x i8], [15 x i8]* @.str_val, i64 0, i64 0), i32 %i, i32 %val)
  br label %inc

inc:                                              ; preds = %print_val, %print_inf
  %i.next = add nuw nsw i32 %i, 1
  br label %loop

exit:                                             ; preds = %loop
  ret void
}
