; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/7/bubblesort_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/7/bubblesort_function.ll"
target triple = "x86_64-pc-linux-gnu"

define void @bubble_sort(i32* %arr, i64 %n) {
entry:
  %cmp_n_le1 = icmp ult i64 %n, 2
  br i1 %cmp_n_le1, label %ret, label %outer.check

outer.check:                                      ; preds = %inner.exit, %entry
  %ub = phi i64 [ %n, %entry ], [ %last, %inner.exit ]
  %cmp_ub_gt1 = icmp ugt i64 %ub, 1
  br i1 %cmp_ub_gt1, label %inner.check, label %ret

inner.check:                                      ; preds = %outer.check, %inner.latch
  %i = phi i64 [ %i.next, %inner.latch ], [ 1, %outer.check ]
  %last = phi i64 [ %last.phi, %inner.latch ], [ 0, %outer.check ]
  %cmp_i_lt_ub = icmp ult i64 %i, %ub
  br i1 %cmp_i_lt_ub, label %inner.body, label %inner.exit

inner.body:                                       ; preds = %inner.check
  %im1 = add i64 %i, -1
  %p1 = getelementptr inbounds i32, i32* %arr, i64 %im1
  %v1 = load i32, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %arr, i64 %i
  %v2 = load i32, i32* %p2, align 4
  %cmp_gt = icmp sgt i32 %v1, %v2
  br i1 %cmp_gt, label %swap, label %inner.latch

swap:                                             ; preds = %inner.body
  store i32 %v2, i32* %p1, align 4
  store i32 %v1, i32* %p2, align 4
  br label %inner.latch

inner.latch:                                      ; preds = %swap, %inner.body
  %last.phi = phi i64 [ %i, %swap ], [ %last, %inner.body ]
  %i.next = add nuw i64 %i, 1
  br label %inner.check

inner.exit:                                       ; preds = %inner.check
  %no_swaps = icmp eq i64 %last, 0
  br i1 %no_swaps, label %ret, label %outer.check

ret:                                              ; preds = %inner.exit, %outer.check, %entry
  ret void
}
