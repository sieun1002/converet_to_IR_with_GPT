; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/1/bubblesort_function.ll'
source_filename = "bubble_sort"

define void @bubble_sort(i32* nocapture %arr, i64 %n) {
entry:
  %cmp_n_le1 = icmp ult i64 %n, 2
  br i1 %cmp_n_le1, label %return, label %outer.header

outer.header:                                     ; preds = %after.inner, %entry
  %bound = phi i64 [ %n, %entry ], [ %last, %after.inner ]
  %cond_outer = icmp ugt i64 %bound, 1
  br i1 %cond_outer, label %inner.header, label %return

inner.header:                                     ; preds = %outer.header, %inner.latch
  %i = phi i64 [ %i.next, %inner.latch ], [ 1, %outer.header ]
  %last = phi i64 [ %last.updated, %inner.latch ], [ 0, %outer.header ]
  %cond_inner = icmp ult i64 %i, %bound
  br i1 %cond_inner, label %inner.body, label %after.inner

inner.body:                                       ; preds = %inner.header
  %im1 = add i64 %i, -1
  %ptr_im1 = getelementptr inbounds i32, i32* %arr, i64 %im1
  %a = load i32, i32* %ptr_im1, align 4
  %ptr_i = getelementptr inbounds i32, i32* %arr, i64 %i
  %b = load i32, i32* %ptr_i, align 4
  %cmp_gt = icmp sgt i32 %a, %b
  br i1 %cmp_gt, label %do.swap, label %inner.latch

do.swap:                                          ; preds = %inner.body
  store i32 %b, i32* %ptr_im1, align 4
  store i32 %a, i32* %ptr_i, align 4
  br label %inner.latch

inner.latch:                                      ; preds = %inner.body, %do.swap
  %last.updated = phi i64 [ %i, %do.swap ], [ %last, %inner.body ]
  %i.next = add i64 %i, 1
  br label %inner.header

after.inner:                                      ; preds = %inner.header
  %had.swap.not = icmp eq i64 %last, 0
  br i1 %had.swap.not, label %return, label %outer.header

return:                                           ; preds = %after.inner, %outer.header, %entry
  ret void
}
