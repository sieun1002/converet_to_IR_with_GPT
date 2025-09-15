; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/8/dijkstra_modular_function6.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/8/dijkstra_modular_function6.ll"
target triple = "x86_64-pc-windows-msvc"

@.str.inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00", align 1
@.str.val = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00", align 1

declare i32 @printf(i8*, ...)

define void @print_distances(i32* %dist, i32 %n) {
entry:
  br label %loop

loop:                                             ; preds = %latch, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %latch ]
  %cond = icmp slt i32 %i, %n
  br i1 %cond, label %body, label %exit

body:                                             ; preds = %loop
  %0 = zext i32 %i to i64
  %p = getelementptr inbounds i32, i32* %dist, i64 %0
  %v = load i32, i32* %p, align 4
  %isinf = icmp eq i32 %v, 2147483647
  br i1 %isinf, label %print_inf, label %print_val

print_inf:                                        ; preds = %body
  %call1 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([16 x i8], [16 x i8]* @.str.inf, i64 0, i64 0), i32 %i)
  br label %latch

print_val:                                        ; preds = %body
  %call2 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([15 x i8], [15 x i8]* @.str.val, i64 0, i64 0), i32 %i, i32 %v)
  br label %latch

latch:                                            ; preds = %print_val, %print_inf
  %i.next = add nuw nsw i32 %i, 1
  br label %loop

exit:                                             ; preds = %loop
  ret void
}
