; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/5/bubblesort_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/5/bubblesort_function.ll"

define void @bubble_sort(i32* %arr, i64 %n) {
entry:
  %small = icmp ult i64 %n, 2
  br i1 %small, label %ret, label %outer_test

outer_test:                                       ; preds = %after_inner, %entry
  %bound = phi i64 [ %n, %entry ], [ %last, %after_inner ]
  %cond = icmp ugt i64 %bound, 1
  br i1 %cond, label %inner_header, label %ret

inner_header:                                     ; preds = %outer_test, %after_compare
  %i = phi i64 [ %i_next, %after_compare ], [ 1, %outer_test ]
  %last = phi i64 [ %last_next, %after_compare ], [ 0, %outer_test ]
  %cmpi = icmp ult i64 %i, %bound
  br i1 %cmpi, label %inner_body, label %after_inner

inner_body:                                       ; preds = %inner_header
  %im1 = add i64 %i, -1
  %ptrL = getelementptr inbounds i32, i32* %arr, i64 %im1
  %ptrR = getelementptr inbounds i32, i32* %arr, i64 %i
  %valL = load i32, i32* %ptrL, align 4
  %valR = load i32, i32* %ptrR, align 4
  %gt = icmp sgt i32 %valL, %valR
  br i1 %gt, label %do_swap, label %after_compare

do_swap:                                          ; preds = %inner_body
  store i32 %valR, i32* %ptrL, align 4
  store i32 %valL, i32* %ptrR, align 4
  br label %after_compare

after_compare:                                    ; preds = %inner_body, %do_swap
  %last_next = phi i64 [ %i, %do_swap ], [ %last, %inner_body ]
  %i_next = add i64 %i, 1
  br label %inner_header

after_inner:                                      ; preds = %inner_header
  %zero = icmp eq i64 %last, 0
  br i1 %zero, label %ret, label %outer_test

ret:                                              ; preds = %after_inner, %outer_test, %entry
  ret void
}
