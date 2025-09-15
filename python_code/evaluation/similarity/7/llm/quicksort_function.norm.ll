; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/7/quicksort_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/7/quicksort_function.ll"
target triple = "x86_64-pc-linux-gnu"

define dso_local void @quick_sort(i32* nocapture %arr, i64 %lo, i64 %hi) {
entry:
  br label %while.cond

while.cond:                                       ; preds = %continue, %entry
  %lo.cur = phi i64 [ %lo, %entry ], [ %lo.next, %continue ]
  %hi.cur = phi i64 [ %hi, %entry ], [ %hi.next, %continue ]
  %cmp0 = icmp sgt i64 %hi.cur, %lo.cur
  br i1 %cmp0, label %partition.init, label %end

partition.init:                                   ; preds = %while.cond
  %delta = sub i64 %hi.cur, %lo.cur
  %shr.sign = lshr i64 %delta, 63
  %adj = add i64 %delta, %shr.sign
  %half = ashr i64 %adj, 1
  %mid = add i64 %lo.cur, %half
  %gep.mid = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot = load i32, i32* %gep.mid, align 4
  br label %part.loop.header

part.loop.header:                                 ; preds = %do.swap, %partition.init
  %i.ph = phi i64 [ %lo.cur, %partition.init ], [ %i.after.swap, %do.swap ]
  %j.ph = phi i64 [ %hi.cur, %partition.init ], [ %j.after.swap, %do.swap ]
  br label %inc.i.loop

inc.i.loop:                                       ; preds = %inc.i.body, %part.loop.header
  %i.cur = phi i64 [ %i.ph, %part.loop.header ], [ %i.inc, %inc.i.body ]
  %gep.i = getelementptr inbounds i32, i32* %arr, i64 %i.cur
  %val.i = load i32, i32* %gep.i, align 4
  %lt = icmp slt i32 %val.i, %pivot
  br i1 %lt, label %inc.i.body, label %dec.j.loop

inc.i.body:                                       ; preds = %inc.i.loop
  %i.inc = add i64 %i.cur, 1
  br label %inc.i.loop

dec.j.loop:                                       ; preds = %inc.i.loop, %dec.j.body
  %j.cur = phi i64 [ %j.dec, %dec.j.body ], [ %j.ph, %inc.i.loop ]
  %gep.j = getelementptr inbounds i32, i32* %arr, i64 %j.cur
  %val.j = load i32, i32* %gep.j, align 4
  %gt = icmp sgt i32 %val.j, %pivot
  br i1 %gt, label %dec.j.body, label %dec.j.done

dec.j.body:                                       ; preds = %dec.j.loop
  %j.dec = add i64 %j.cur, -1
  br label %dec.j.loop

dec.j.done:                                       ; preds = %dec.j.loop
  %cmp.le.not = icmp sgt i64 %i.cur, %j.cur
  br i1 %cmp.le.not, label %part.exit, label %do.swap

do.swap:                                          ; preds = %dec.j.done
  store i32 %val.j, i32* %gep.i, align 4
  store i32 %val.i, i32* %gep.j, align 4
  %i.after.swap = add i64 %i.cur, 1
  %j.after.swap = add i64 %j.cur, -1
  %cmp.after.not = icmp sgt i64 %i.after.swap, %j.after.swap
  br i1 %cmp.after.not, label %part.exit, label %part.loop.header

part.exit:                                        ; preds = %dec.j.done, %do.swap
  %i.exit = phi i64 [ %i.after.swap, %do.swap ], [ %i.cur, %dec.j.done ]
  %j.exit = phi i64 [ %j.after.swap, %do.swap ], [ %j.cur, %dec.j.done ]
  %left.len = sub i64 %j.exit, %lo.cur
  %right.len = sub i64 %hi.cur, %i.exit
  %left.ge.right.not = icmp slt i64 %left.len, %right.len
  br i1 %left.ge.right.not, label %left.first, label %right.first

left.first:                                       ; preds = %part.exit
  %need.left = icmp sgt i64 %j.exit, %lo.cur
  br i1 %need.left, label %call.left, label %continue

call.left:                                        ; preds = %left.first
  call void @quick_sort(i32* %arr, i64 %lo.cur, i64 %j.exit)
  br label %continue

right.first:                                      ; preds = %part.exit
  %need.right = icmp sgt i64 %hi.cur, %i.exit
  br i1 %need.right, label %call.right, label %continue

call.right:                                       ; preds = %right.first
  call void @quick_sort(i32* %arr, i64 %i.exit, i64 %hi.cur)
  br label %continue

continue:                                         ; preds = %right.first, %call.right, %left.first, %call.left
  %lo.next = phi i64 [ %i.exit, %call.left ], [ %i.exit, %left.first ], [ %lo.cur, %call.right ], [ %lo.cur, %right.first ]
  %hi.next = phi i64 [ %hi.cur, %call.left ], [ %hi.cur, %left.first ], [ %j.exit, %call.right ], [ %j.exit, %right.first ]
  br label %while.cond

end:                                              ; preds = %while.cond
  ret void
}
