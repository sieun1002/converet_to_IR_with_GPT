; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/6/quicksort_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/6/quicksort_function.ll"

define void @quick_sort(i32* %arr, i64 %left, i64 %right) {
entry:
  br label %outer.header

outer.header:                                     ; preds = %cont.right, %cont.left, %entry
  %left.ph = phi i64 [ %left, %entry ], [ %i.c, %cont.left ], [ %left.ph, %cont.right ]
  %right.ph = phi i64 [ %right, %entry ], [ %right.ph, %cont.left ], [ %j.c, %cont.right ]
  %cmp.outer = icmp sgt i64 %right.ph, %left.ph
  br i1 %cmp.outer, label %partition.init, label %return

partition.init:                                   ; preds = %outer.header
  %diff = sub i64 %right.ph, %left.ph
  %half = sdiv i64 %diff, 2
  %mid = add i64 %left.ph, %half
  %mid.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot = load i32, i32* %mid.ptr, align 4
  br label %inner.iter

inner.iter:                                       ; preds = %do.swap, %partition.init
  %i.cur = phi i64 [ %left.ph, %partition.init ], [ %i.after, %do.swap ]
  %j.cur = phi i64 [ %right.ph, %partition.init ], [ %j.after, %do.swap ]
  br label %inc_i.loop

inc_i.loop:                                       ; preds = %inc_i.body, %inner.iter
  %i.c = phi i64 [ %i.cur, %inner.iter ], [ %i.inc, %inc_i.body ]
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.c
  %i.val = load i32, i32* %i.ptr, align 4
  %cmp.i = icmp slt i32 %i.val, %pivot
  br i1 %cmp.i, label %inc_i.body, label %dec_j.loop

inc_i.body:                                       ; preds = %inc_i.loop
  %i.inc = add i64 %i.c, 1
  br label %inc_i.loop

dec_j.loop:                                       ; preds = %inc_i.loop, %dec_j.body
  %j.c = phi i64 [ %j.dec, %dec_j.body ], [ %j.cur, %inc_i.loop ]
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.c
  %j.val = load i32, i32* %j.ptr, align 4
  %cmp.j = icmp sgt i32 %j.val, %pivot
  br i1 %cmp.j, label %dec_j.body, label %cmp.swap

dec_j.body:                                       ; preds = %dec_j.loop
  %j.dec = add i64 %j.c, -1
  br label %dec_j.loop

cmp.swap:                                         ; preds = %dec_j.loop
  %cmp.ij = icmp sgt i64 %i.c, %j.c
  br i1 %cmp.ij, label %after.partition, label %do.swap

do.swap:                                          ; preds = %cmp.swap
  store i32 %j.val, i32* %i.ptr, align 4
  store i32 %i.val, i32* %j.ptr, align 4
  %j.after = add i64 %j.c, -1
  %i.after = add i64 %i.c, 1
  br label %inner.iter

after.partition:                                  ; preds = %cmp.swap
  %size.left = sub i64 %j.c, %left.ph
  %size.right = sub i64 %right.ph, %i.c
  %left.smaller = icmp slt i64 %size.left, %size.right
  br i1 %left.smaller, label %left.case, label %right.case

left.case:                                        ; preds = %after.partition
  %cond.left = icmp sgt i64 %j.c, %left.ph
  br i1 %cond.left, label %left.call, label %cont.left

left.call:                                        ; preds = %left.case
  call void @quick_sort(i32* %arr, i64 %left.ph, i64 %j.c)
  br label %cont.left

cont.left:                                        ; preds = %left.case, %left.call
  br label %outer.header

right.case:                                       ; preds = %after.partition
  %cond.right = icmp sgt i64 %right.ph, %i.c
  br i1 %cond.right, label %right.call, label %cont.right

right.call:                                       ; preds = %right.case
  call void @quick_sort(i32* %arr, i64 %i.c, i64 %right.ph)
  br label %cont.right

cont.right:                                       ; preds = %right.case, %right.call
  br label %outer.header

return:                                           ; preds = %outer.header
  ret void
}
