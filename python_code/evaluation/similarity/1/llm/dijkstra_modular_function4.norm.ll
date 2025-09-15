; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/1/dijkstra_modular_function4.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/1/dijkstra_modular_function4.ll"
target triple = "x86_64-pc-linux-gnu"

define i32 @min_index(i32* nocapture readonly %a, i32* nocapture readonly %b, i32 %n) {
entry:
  br label %loop.header

loop.header:                                      ; preds = %cont, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %cont ]
  %minv = phi i32 [ 2147483647, %entry ], [ %minv.next, %cont ]
  %idx = phi i32 [ -1, %entry ], [ %idx.next, %cont ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %loop.body, label %exit

loop.body:                                        ; preds = %loop.header
  %0 = zext i32 %i to i64
  %b.ptr = getelementptr inbounds i32, i32* %b, i64 %0
  %b.val = load i32, i32* %b.ptr, align 4
  %b.isnz.not = icmp eq i32 %b.val, 0
  br i1 %b.isnz.not, label %maybe, label %noUpdate

maybe:                                            ; preds = %loop.body
  %a.ptr = getelementptr inbounds i32, i32* %a, i64 %0
  %a.val = load i32, i32* %a.ptr, align 4
  %isless = icmp slt i32 %a.val, %minv
  br i1 %isless, label %cont, label %noUpdate

noUpdate:                                         ; preds = %maybe, %loop.body
  br label %cont

cont:                                             ; preds = %maybe, %noUpdate
  %minv.next = phi i32 [ %minv, %noUpdate ], [ %a.val, %maybe ]
  %idx.next = phi i32 [ %idx, %noUpdate ], [ %i, %maybe ]
  %i.next = add nuw nsw i32 %i, 1
  br label %loop.header

exit:                                             ; preds = %loop.header
  ret i32 %idx
}
