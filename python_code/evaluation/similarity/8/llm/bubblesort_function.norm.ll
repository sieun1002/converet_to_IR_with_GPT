; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/8/bubblesort_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/8/bubblesort_function.ll"
target triple = "x86_64-pc-linux-gnu"

define void @bubble_sort(i32* %arr, i64 %n) {
entry:
  %cmp0 = icmp ult i64 %n, 2
  br i1 %cmp0, label %ret, label %outer.header

outer.header:                                     ; preds = %inner.exit, %entry
  %newn = phi i64 [ %n, %entry ], [ %last.cur, %inner.exit ]
  %cmp1 = icmp ugt i64 %newn, 1
  br i1 %cmp1, label %inner.header, label %ret

inner.header:                                     ; preds = %outer.header, %inner.latch
  %i = phi i64 [ %i.next, %inner.latch ], [ 1, %outer.header ]
  %last.cur = phi i64 [ %last.next, %inner.latch ], [ 0, %outer.header ]
  %cmp2 = icmp ult i64 %i, %newn
  br i1 %cmp2, label %inner.body, label %inner.exit

inner.body:                                       ; preds = %inner.header
  %idx.im1 = add i64 %i, -1
  %ptr.im1 = getelementptr inbounds i32, i32* %arr, i64 %idx.im1
  %val.im1 = load i32, i32* %ptr.im1, align 4
  %ptr.i = getelementptr inbounds i32, i32* %arr, i64 %i
  %val.i = load i32, i32* %ptr.i, align 4
  %cmp3 = icmp sgt i32 %val.im1, %val.i
  br i1 %cmp3, label %swap, label %inner.latch

swap:                                             ; preds = %inner.body
  store i32 %val.i, i32* %ptr.im1, align 4
  store i32 %val.im1, i32* %ptr.i, align 4
  br label %inner.latch

inner.latch:                                      ; preds = %inner.body, %swap
  %last.next = phi i64 [ %i, %swap ], [ %last.cur, %inner.body ]
  %i.next = add i64 %i, 1
  br label %inner.header

inner.exit:                                       ; preds = %inner.header
  %iszero = icmp eq i64 %last.cur, 0
  br i1 %iszero, label %ret, label %outer.header

ret:                                              ; preds = %inner.exit, %outer.header, %entry
  ret void
}
