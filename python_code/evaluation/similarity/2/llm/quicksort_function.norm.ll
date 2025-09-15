; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/2/quicksort_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/2/quicksort_function.ll"
target triple = "x86_64-pc-linux-gnu"

define void @quick_sort(i32* nocapture %arr, i64 %lo, i64 %hi) {
entry:
  br label %outer

outer:                                            ; preds = %outer.cont, %entry
  %lo.cur = phi i64 [ %lo, %entry ], [ %lo.next, %outer.cont ]
  %hi.cur = phi i64 [ %hi, %entry ], [ %hi.next, %outer.cont ]
  %cmp.outer = icmp sgt i64 %hi.cur, %lo.cur
  br i1 %cmp.outer, label %part.init, label %ret

part.init:                                        ; preds = %outer
  %delta = sub i64 %hi.cur, %lo.cur
  %neg = lshr i64 %delta, 63
  %biased = add i64 %delta, %neg
  %half = ashr i64 %biased, 1
  %mid = add i64 %lo.cur, %half
  %ptr.mid = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot = load i32, i32* %ptr.mid, align 4
  br label %inc_i.check

inc_i.check:                                      ; preds = %swap.true, %inc_i.inc, %part.init
  %i.cur = phi i64 [ %lo.cur, %part.init ], [ %i.next, %inc_i.inc ], [ %i.after.swap, %swap.true ]
  %j.pass = phi i64 [ %hi.cur, %part.init ], [ %j.pass, %inc_i.inc ], [ %j.after.swap, %swap.true ]
  %iptr = getelementptr inbounds i32, i32* %arr, i64 %i.cur
  %ival = load i32, i32* %iptr, align 4
  %cmp.i = icmp sgt i32 %pivot, %ival
  br i1 %cmp.i, label %inc_i.inc, label %dec_j.check

inc_i.inc:                                        ; preds = %inc_i.check
  %i.next = add i64 %i.cur, 1
  br label %inc_i.check

dec_j.check:                                      ; preds = %dec_j.dec, %inc_i.check
  %j.cur = phi i64 [ %j.pass, %inc_i.check ], [ %j.next, %dec_j.dec ]
  %jptr = getelementptr inbounds i32, i32* %arr, i64 %j.cur
  %jval = load i32, i32* %jptr, align 4
  %cmp.j = icmp slt i32 %pivot, %jval
  br i1 %cmp.j, label %dec_j.dec, label %check.swap

dec_j.dec:                                        ; preds = %dec_j.check
  %j.next = add i64 %j.cur, -1
  br label %dec_j.check

check.swap:                                       ; preds = %dec_j.check
  %cmp.ij.not = icmp sgt i64 %i.cur, %j.cur
  br i1 %cmp.ij.not, label %choose, label %swap.true

swap.true:                                        ; preds = %check.swap
  store i32 %jval, i32* %iptr, align 4
  store i32 %ival, i32* %jptr, align 4
  %i.after.swap = add i64 %i.cur, 1
  %j.after.swap = add i64 %j.cur, -1
  br label %inc_i.check

choose:                                           ; preds = %check.swap
  %left.len = sub i64 %j.cur, %lo.cur
  %right.len = sub i64 %hi.cur, %i.cur
  %left.smaller = icmp slt i64 %left.len, %right.len
  br i1 %left.smaller, label %do.left, label %do.right

do.left:                                          ; preds = %choose
  %need.left = icmp sgt i64 %j.cur, %lo.cur
  br i1 %need.left, label %call.left, label %outer.cont

call.left:                                        ; preds = %do.left
  call void @quick_sort(i32* %arr, i64 %lo.cur, i64 %j.cur)
  br label %outer.cont

do.right:                                         ; preds = %choose
  %need.right = icmp sgt i64 %hi.cur, %i.cur
  br i1 %need.right, label %call.right, label %outer.cont

call.right:                                       ; preds = %do.right
  call void @quick_sort(i32* %arr, i64 %i.cur, i64 %hi.cur)
  br label %outer.cont

outer.cont:                                       ; preds = %do.right, %call.right, %do.left, %call.left
  %lo.next = phi i64 [ %i.cur, %call.left ], [ %i.cur, %do.left ], [ %lo.cur, %call.right ], [ %lo.cur, %do.right ]
  %hi.next = phi i64 [ %hi.cur, %call.left ], [ %hi.cur, %do.left ], [ %j.cur, %call.right ], [ %j.cur, %do.right ]
  br label %outer

ret:                                              ; preds = %outer
  ret void
}
