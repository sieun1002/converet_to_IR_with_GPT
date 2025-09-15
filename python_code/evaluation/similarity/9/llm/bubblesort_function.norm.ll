; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/9/bubblesort_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/9/bubblesort_function.ll"
target triple = "x86_64-pc-linux-gnu"

define void @bubble_sort(i32* %a, i64 %n) {
entry:
  %cmp.n.le1 = icmp ult i64 %n, 2
  br i1 %cmp.n.le1, label %exit, label %outer_header

outer_header:                                     ; preds = %entry, %after_inner
  %limit = phi i64 [ %last, %after_inner ], [ %n, %entry ]
  %cmp.limit.gt1 = icmp ugt i64 %limit, 1
  br i1 %cmp.limit.gt1, label %inner_header, label %exit

inner_header:                                     ; preds = %outer_header, %cont
  %i = phi i64 [ %i.next, %cont ], [ 1, %outer_header ]
  %last = phi i64 [ %last.updated, %cont ], [ 0, %outer_header ]
  %cmp.i.lt.limit = icmp ult i64 %i, %limit
  br i1 %cmp.i.lt.limit, label %inner_body, label %after_inner

inner_body:                                       ; preds = %inner_header
  %i.minus.1 = add i64 %i, -1
  %ptr.prev = getelementptr inbounds i32, i32* %a, i64 %i.minus.1
  %val.prev = load i32, i32* %ptr.prev, align 4
  %ptr.i = getelementptr inbounds i32, i32* %a, i64 %i
  %val.i = load i32, i32* %ptr.i, align 4
  %cmp.swap = icmp sgt i32 %val.prev, %val.i
  br i1 %cmp.swap, label %do_swap, label %cont

do_swap:                                          ; preds = %inner_body
  store i32 %val.i, i32* %ptr.prev, align 4
  store i32 %val.prev, i32* %ptr.i, align 4
  br label %cont

cont:                                             ; preds = %inner_body, %do_swap
  %last.updated = phi i64 [ %i, %do_swap ], [ %last, %inner_body ]
  %i.next = add i64 %i, 1
  br label %inner_header

after_inner:                                      ; preds = %inner_header
  %last.eq.zero = icmp eq i64 %last, 0
  br i1 %last.eq.zero, label %exit, label %outer_header

exit:                                             ; preds = %after_inner, %outer_header, %entry
  ret void
}
