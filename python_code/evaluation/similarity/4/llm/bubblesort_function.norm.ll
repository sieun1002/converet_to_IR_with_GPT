; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/4/bubblesort_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/4/bubblesort_function.ll"

define void @bubble_sort(i32* %a, i64 %n) {
entry:
  %cmp0 = icmp ult i64 %n, 2
  br i1 %cmp0, label %ret, label %outer.check

outer.check:                                      ; preds = %afterInner, %entry
  %last = phi i64 [ %n, %entry ], [ %last_swap, %afterInner ]
  %cmpLast = icmp ugt i64 %last, 1
  br i1 %cmpLast, label %inner.cond, label %ret

inner.cond:                                       ; preds = %outer.check, %inner.latch
  %i = phi i64 [ %i.next, %inner.latch ], [ 1, %outer.check ]
  %last_swap = phi i64 [ %ls.update, %inner.latch ], [ 0, %outer.check ]
  %cmpI = icmp ult i64 %i, %last
  br i1 %cmpI, label %inner.body, label %afterInner

inner.body:                                       ; preds = %inner.cond
  %im1 = add i64 %i, -1
  %ptrPrev = getelementptr inbounds i32, i32* %a, i64 %im1
  %ptrCurr = getelementptr inbounds i32, i32* %a, i64 %i
  %valPrev = load i32, i32* %ptrPrev, align 4
  %valCurr = load i32, i32* %ptrCurr, align 4
  %cmpSwap = icmp sgt i32 %valPrev, %valCurr
  br i1 %cmpSwap, label %do.swap, label %inner.latch

do.swap:                                          ; preds = %inner.body
  store i32 %valCurr, i32* %ptrPrev, align 4
  store i32 %valPrev, i32* %ptrCurr, align 4
  br label %inner.latch

inner.latch:                                      ; preds = %inner.body, %do.swap
  %ls.update = phi i64 [ %i, %do.swap ], [ %last_swap, %inner.body ]
  %i.next = add i64 %i, 1
  br label %inner.cond

afterInner:                                       ; preds = %inner.cond
  %isZero = icmp eq i64 %last_swap, 0
  br i1 %isZero, label %ret, label %outer.check

ret:                                              ; preds = %afterInner, %outer.check, %entry
  ret void
}
