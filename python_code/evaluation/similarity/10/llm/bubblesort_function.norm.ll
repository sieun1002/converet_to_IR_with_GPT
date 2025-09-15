; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/10/bubblesort_function.ll'
source_filename = "bubble_sort.ll"
target triple = "x86_64-unknown-linux-gnu"

define void @bubble_sort(i32* nocapture %a, i64 %n) local_unnamed_addr {
entry:
  %cmp.init = icmp ult i64 %n, 2
  br i1 %cmp.init, label %ret, label %outer.cond

outer.cond:                                       ; preds = %inner.end, %entry
  %limit = phi i64 [ %n, %entry ], [ %last_swap, %inner.end ]
  %cmp.limit = icmp ugt i64 %limit, 1
  br i1 %cmp.limit, label %inner.cond, label %ret

inner.cond:                                       ; preds = %outer.cond, %inner.body.end
  %j = phi i64 [ %j.next, %inner.body.end ], [ 1, %outer.cond ]
  %last_swap = phi i64 [ %last.next, %inner.body.end ], [ 0, %outer.cond ]
  %cond.inner = icmp ult i64 %j, %limit
  br i1 %cond.inner, label %inner.body, label %inner.end

inner.body:                                       ; preds = %inner.cond
  %j.minus1 = add i64 %j, -1
  %ptr1 = getelementptr inbounds i32, i32* %a, i64 %j.minus1
  %ptr2 = getelementptr inbounds i32, i32* %a, i64 %j
  %val1 = load i32, i32* %ptr1, align 4
  %val2 = load i32, i32* %ptr2, align 4
  %cmp.swap = icmp sgt i32 %val1, %val2
  br i1 %cmp.swap, label %do.swap, label %inner.body.end

do.swap:                                          ; preds = %inner.body
  store i32 %val2, i32* %ptr1, align 4
  store i32 %val1, i32* %ptr2, align 4
  br label %inner.body.end

inner.body.end:                                   ; preds = %inner.body, %do.swap
  %last.next = phi i64 [ %j, %do.swap ], [ %last_swap, %inner.body ]
  %j.next = add i64 %j, 1
  br label %inner.cond

inner.end:                                        ; preds = %inner.cond
  %last.zero = icmp eq i64 %last_swap, 0
  br i1 %last.zero, label %ret, label %outer.cond

ret:                                              ; preds = %inner.end, %outer.cond, %entry
  ret void
}
