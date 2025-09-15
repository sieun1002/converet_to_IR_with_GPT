; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/2/bubblesort_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/2/bubblesort_function.ll"

define void @bubble_sort(i32* %arr, i64 %n) {
entry:
  %cmp0 = icmp ult i64 %n, 2
  br i1 %cmp0, label %ret, label %outer.header

outer.header:                                     ; preds = %after.inner, %entry
  %limit = phi i64 [ %n, %entry ], [ %last, %after.inner ]
  %gt1 = icmp ugt i64 %limit, 1
  br i1 %gt1, label %inner.header, label %ret

inner.header:                                     ; preds = %outer.header, %inc
  %j = phi i64 [ %j.next, %inc ], [ 1, %outer.header ]
  %last = phi i64 [ %last.updated, %inc ], [ 0, %outer.header ]
  %j_lt_limit = icmp ult i64 %j, %limit
  br i1 %j_lt_limit, label %inner.body, label %after.inner

inner.body:                                       ; preds = %inner.header
  %jm1 = add i64 %j, -1
  %ptr.prev = getelementptr inbounds i32, i32* %arr, i64 %jm1
  %ptr.cur = getelementptr inbounds i32, i32* %arr, i64 %j
  %v.prev = load i32, i32* %ptr.prev, align 4
  %v.cur = load i32, i32* %ptr.cur, align 4
  %need.swap = icmp sgt i32 %v.prev, %v.cur
  br i1 %need.swap, label %swap, label %inc

swap:                                             ; preds = %inner.body
  store i32 %v.cur, i32* %ptr.prev, align 4
  store i32 %v.prev, i32* %ptr.cur, align 4
  br label %inc

inc:                                              ; preds = %inner.body, %swap
  %last.updated = phi i64 [ %j, %swap ], [ %last, %inner.body ]
  %j.next = add i64 %j, 1
  br label %inner.header

after.inner:                                      ; preds = %inner.header
  %no.swaps = icmp eq i64 %last, 0
  br i1 %no.swaps, label %ret, label %outer.header

ret:                                              ; preds = %after.inner, %outer.header, %entry
  ret void
}
