; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/3/quicksort_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/3/quicksort_function.ll"
target triple = "x86_64-pc-linux-gnu"

define void @quick_sort(i32* noundef %arr, i64 noundef %low, i64 noundef %high) local_unnamed_addr {
entry:
  br label %loop.check

loop.check:                                       ; preds = %after.right.call, %after.left.call, %entry
  %low.cur = phi i64 [ %low, %entry ], [ %i.cur, %after.left.call ], [ %low.cur, %after.right.call ]
  %high.cur = phi i64 [ %high, %entry ], [ %high.cur, %after.left.call ], [ %j.cur2, %after.right.call ]
  %cmp.lh = icmp sgt i64 %high.cur, %low.cur
  br i1 %cmp.lh, label %part.init, label %exit

part.init:                                        ; preds = %loop.check
  %diff = sub i64 %high.cur, %low.cur
  %sign = lshr i64 %diff, 63
  %diff.adj = add i64 %diff, %sign
  %half = ashr i64 %diff.adj, 1
  %mid = add i64 %low.cur, %half
  %pivot.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot = load i32, i32* %pivot.ptr, align 4
  br label %i.scan

i.scan:                                           ; preds = %swap, %i.inc, %part.init
  %i.cur = phi i64 [ %low.cur, %part.init ], [ %i.inc.val, %i.inc ], [ %i.after.swap, %swap ]
  %j.hold = phi i64 [ %high.cur, %part.init ], [ %j.hold, %i.inc ], [ %j.after.swap, %swap ]
  %ptr.i = getelementptr inbounds i32, i32* %arr, i64 %i.cur
  %val.i.cur = load i32, i32* %ptr.i, align 4
  %cmp.i = icmp sgt i32 %pivot, %val.i.cur
  br i1 %cmp.i, label %i.inc, label %j.scan

i.inc:                                            ; preds = %i.scan
  %i.inc.val = add nsw i64 %i.cur, 1
  br label %i.scan

j.scan:                                           ; preds = %j.dec, %i.scan
  %j.cur2 = phi i64 [ %j.hold, %i.scan ], [ %j.dec.val, %j.dec ]
  %ptr.j = getelementptr inbounds i32, i32* %arr, i64 %j.cur2
  %val.j.cur = load i32, i32* %ptr.j, align 4
  %cmp.j = icmp slt i32 %pivot, %val.j.cur
  br i1 %cmp.j, label %j.dec, label %compare

j.dec:                                            ; preds = %j.scan
  %j.dec.val = add nsw i64 %j.cur2, -1
  br label %j.scan

compare:                                          ; preds = %j.scan
  %le.ij.not = icmp sgt i64 %i.cur, %j.cur2
  br i1 %le.ij.not, label %part.done, label %swap

swap:                                             ; preds = %compare
  store i32 %val.j.cur, i32* %ptr.i, align 4
  store i32 %val.i.cur, i32* %ptr.j, align 4
  %i.after.swap = add nsw i64 %i.cur, 1
  %j.after.swap = add nsw i64 %j.cur2, -1
  br label %i.scan

part.done:                                        ; preds = %compare
  %left.size = sub nsw i64 %j.cur2, %low.cur
  %right.size = sub nsw i64 %high.cur, %i.cur
  %choose.right.not = icmp slt i64 %left.size, %right.size
  br i1 %choose.right.not, label %cont.left, label %cont.right

cont.left:                                        ; preds = %part.done
  %do.left = icmp sgt i64 %j.cur2, %low.cur
  br i1 %do.left, label %call.left, label %after.left.call

call.left:                                        ; preds = %cont.left
  call void @quick_sort(i32* noundef %arr, i64 noundef %low.cur, i64 noundef %j.cur2)
  br label %after.left.call

after.left.call:                                  ; preds = %call.left, %cont.left
  br label %loop.check

cont.right:                                       ; preds = %part.done
  %do.right = icmp sgt i64 %high.cur, %i.cur
  br i1 %do.right, label %call.right, label %after.right.call

call.right:                                       ; preds = %cont.right
  call void @quick_sort(i32* noundef %arr, i64 noundef %i.cur, i64 noundef %high.cur)
  br label %after.right.call

after.right.call:                                 ; preds = %call.right, %cont.right
  br label %loop.check

exit:                                             ; preds = %loop.check
  ret void
}
