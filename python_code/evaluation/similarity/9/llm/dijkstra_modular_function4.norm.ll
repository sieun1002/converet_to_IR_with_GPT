; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/9/dijkstra_modular_function4.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/9/dijkstra_modular_function4.ll"
target triple = "x86_64-pc-linux-gnu"

define dso_local i32 @min_index(i32* nocapture readonly %arr, i32* nocapture readonly %flags, i32 %len) local_unnamed_addr {
entry:
  br label %loop

loop:                                             ; preds = %inc, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %inc ]
  %minval = phi i32 [ 2147483647, %entry ], [ %minval.next, %inc ]
  %minidx = phi i32 [ -1, %entry ], [ %minidx.next, %inc ]
  %cmp.len.not = icmp slt i32 %i, %len
  br i1 %cmp.len.not, label %checkflag, label %exit

checkflag:                                        ; preds = %loop
  %idx.ext = zext i32 %i to i64
  %flag.ptr = getelementptr inbounds i32, i32* %flags, i64 %idx.ext
  %flag.val = load i32, i32* %flag.ptr, align 4
  %flag.nz.not = icmp eq i32 %flag.val, 0
  br i1 %flag.nz.not, label %checkmin, label %inc

checkmin:                                         ; preds = %checkflag
  %arr.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx.ext
  %arr.val = load i32, i32* %arr.ptr, align 4
  %lt = icmp slt i32 %arr.val, %minval
  %spec.select = select i1 %lt, i32 %arr.val, i32 %minval
  %spec.select1 = select i1 %lt, i32 %i, i32 %minidx
  br label %inc

inc:                                              ; preds = %checkmin, %checkflag
  %minval.next = phi i32 [ %minval, %checkflag ], [ %spec.select, %checkmin ]
  %minidx.next = phi i32 [ %minidx, %checkflag ], [ %spec.select1, %checkmin ]
  %i.next = add nuw nsw i32 %i, 1
  br label %loop

exit:                                             ; preds = %loop
  ret i32 %minidx
}
