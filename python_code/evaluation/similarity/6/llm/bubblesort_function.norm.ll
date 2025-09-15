; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/6/bubblesort_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/6/bubblesort_function.ll"
target triple = "x86_64-pc-linux-gnu"

define void @bubble_sort(i32* %arr, i64 %n) {
entry:
  %cmp_n_le1 = icmp ult i64 %n, 2
  br i1 %cmp_n_le1, label %exit, label %outer.header

outer.header:                                     ; preds = %after.inner, %entry
  %last = phi i64 [ %n, %entry ], [ %lastswap, %after.inner ]
  %cmp_outer = icmp ugt i64 %last, 1
  br i1 %cmp_outer, label %inner.header, label %exit

inner.header:                                     ; preds = %outer.header, %inner.inc
  %i = phi i64 [ %i.next, %inner.inc ], [ 1, %outer.header ]
  %lastswap = phi i64 [ %lastswap.next, %inner.inc ], [ 0, %outer.header ]
  %cmp_inner = icmp ult i64 %i, %last
  br i1 %cmp_inner, label %inner.body, label %after.inner

inner.body:                                       ; preds = %inner.header
  %i.prev = add i64 %i, -1
  %ptr.prev = getelementptr i32, i32* %arr, i64 %i.prev
  %ptr.cur = getelementptr i32, i32* %arr, i64 %i
  %a = load i32, i32* %ptr.prev, align 4
  %b = load i32, i32* %ptr.cur, align 4
  %cmp_swap = icmp sgt i32 %a, %b
  br i1 %cmp_swap, label %do.swap, label %inner.inc

do.swap:                                          ; preds = %inner.body
  store i32 %b, i32* %ptr.prev, align 4
  store i32 %a, i32* %ptr.cur, align 4
  br label %inner.inc

inner.inc:                                        ; preds = %inner.body, %do.swap
  %lastswap.next = phi i64 [ %i, %do.swap ], [ %lastswap, %inner.body ]
  %i.next = add i64 %i, 1
  br label %inner.header

after.inner:                                      ; preds = %inner.header
  %no.swap.any = icmp eq i64 %lastswap, 0
  br i1 %no.swap.any, label %exit, label %outer.header

exit:                                             ; preds = %after.inner, %outer.header, %entry
  ret void
}
