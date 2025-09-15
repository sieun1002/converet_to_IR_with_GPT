; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/4/quicksort_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/4/quicksort_function.ll"

define dso_local void @quick_sort(i32* nocapture %arr, i64 %left, i64 %right) {
entry:
  br label %outer.loop

outer.loop:                                       ; preds = %right.update, %left.update, %entry
  %left.cur = phi i64 [ %left, %entry ], [ %i.cur, %left.update ], [ %left.cur, %right.update ]
  %right.cur = phi i64 [ %right, %entry ], [ %right.cur, %left.update ], [ %j.cur, %right.update ]
  %cmp.outer = icmp sgt i64 %right.cur, %left.cur
  br i1 %cmp.outer, label %partition.entry, label %return

partition.entry:                                  ; preds = %outer.loop
  %diff = sub i64 %right.cur, %left.cur
  %sign = lshr i64 %diff, 63
  %sum = add i64 %diff, %sign
  %half = ashr i64 %sum, 1
  %mid = add i64 %left.cur, %half
  %pivot.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot.val = load i32, i32* %pivot.ptr, align 4
  br label %inc.i.check

inc.i.check:                                      ; preds = %do.swap, %inc.i.body, %partition.entry
  %i.cur = phi i64 [ %left.cur, %partition.entry ], [ %i.next, %inc.i.body ], [ %i.inc, %do.swap ]
  %j.forinc = phi i64 [ %right.cur, %partition.entry ], [ %right.cur, %inc.i.body ], [ %j.dec, %do.swap ]
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.cur
  %i.val = load i32, i32* %i.ptr, align 4
  %cmp.i = icmp slt i32 %i.val, %pivot.val
  br i1 %cmp.i, label %inc.i.body, label %dec.j.check

inc.i.body:                                       ; preds = %inc.i.check
  %i.next = add i64 %i.cur, 1
  br label %inc.i.check

dec.j.check:                                      ; preds = %dec.j.body, %inc.i.check
  %j.cur = phi i64 [ %j.forinc, %inc.i.check ], [ %j.next, %dec.j.body ]
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.cur
  %j.val = load i32, i32* %j.ptr, align 4
  %cmp.j = icmp sgt i32 %j.val, %pivot.val
  br i1 %cmp.j, label %dec.j.body, label %partition.compare

dec.j.body:                                       ; preds = %dec.j.check
  %j.next = add i64 %j.cur, -1
  br label %dec.j.check

partition.compare:                                ; preds = %dec.j.check
  %cmp.le.not = icmp sgt i64 %i.cur, %j.cur
  br i1 %cmp.le.not, label %after.partition, label %do.swap

do.swap:                                          ; preds = %partition.compare
  store i32 %j.val, i32* %i.ptr, align 4
  store i32 %i.val, i32* %j.ptr, align 4
  %i.inc = add i64 %i.cur, 1
  %j.dec = add i64 %j.cur, -1
  br label %inc.i.check

after.partition:                                  ; preds = %partition.compare
  %left.span = sub i64 %j.cur, %left.cur
  %right.span = sub i64 %right.cur, %i.cur
  %cmp.sizes.not = icmp slt i64 %left.span, %right.span
  br i1 %cmp.sizes.not, label %left.branch, label %right.branch

left.branch:                                      ; preds = %after.partition
  %need.left = icmp sgt i64 %j.cur, %left.cur
  br i1 %need.left, label %left.recurse, label %left.update

left.recurse:                                     ; preds = %left.branch
  call void @quick_sort(i32* %arr, i64 %left.cur, i64 %j.cur)
  br label %left.update

left.update:                                      ; preds = %left.recurse, %left.branch
  br label %outer.loop

right.branch:                                     ; preds = %after.partition
  %need.right = icmp sgt i64 %right.cur, %i.cur
  br i1 %need.right, label %right.recurse, label %right.update

right.recurse:                                    ; preds = %right.branch
  call void @quick_sort(i32* %arr, i64 %i.cur, i64 %right.cur)
  br label %right.update

right.update:                                     ; preds = %right.recurse, %right.branch
  br label %outer.loop

return:                                           ; preds = %outer.loop
  ret void
}
