; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/8/quicksort_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/8/quicksort_function.ll"

define void @quick_sort(i32* nocapture %base, i64 %left, i64 %right) local_unnamed_addr {
entry:
  br label %outer.cond

outer.cond:                                       ; preds = %right.no.recurse, %left.no.recurse, %entry
  %left.cur = phi i64 [ %left, %entry ], [ %i.h, %left.no.recurse ], [ %left.cur, %right.no.recurse ]
  %right.cur = phi i64 [ %right, %entry ], [ %right.cur, %left.no.recurse ], [ %j.j, %right.no.recurse ]
  %cmp.lr = icmp sgt i64 %right.cur, %left.cur
  br i1 %cmp.lr, label %partition.init, label %exit

partition.init:                                   ; preds = %outer.cond
  %diff = sub i64 %right.cur, %left.cur
  %diff_shr = lshr i64 %diff, 63
  %adj = add i64 %diff, %diff_shr
  %half = ashr i64 %adj, 1
  %mid = add i64 %left.cur, %half
  %pivot.ptr = getelementptr inbounds i32, i32* %base, i64 %mid
  %pivot.val = load i32, i32* %pivot.ptr, align 4
  br label %i.header

i.header:                                         ; preds = %swap, %i.inc, %partition.init
  %i.h = phi i64 [ %left.cur, %partition.init ], [ %i.next, %i.inc ], [ %i.after.swap, %swap ]
  %j.h = phi i64 [ %right.cur, %partition.init ], [ %j.h, %i.inc ], [ %j.after.swap, %swap ]
  %i.ptr = getelementptr inbounds i32, i32* %base, i64 %i.h
  %i.load = load i32, i32* %i.ptr, align 4
  %cmp.i = icmp slt i32 %i.load, %pivot.val
  br i1 %cmp.i, label %i.inc, label %j.header

i.inc:                                            ; preds = %i.header
  %i.next = add i64 %i.h, 1
  br label %i.header

j.header:                                         ; preds = %j.dec, %i.header
  %j.j = phi i64 [ %j.h, %i.header ], [ %j.next, %j.dec ]
  %j.ptr = getelementptr inbounds i32, i32* %base, i64 %j.j
  %j.load = load i32, i32* %j.ptr, align 4
  %cmp.j = icmp sgt i32 %j.load, %pivot.val
  br i1 %cmp.j, label %j.dec, label %check

j.dec:                                            ; preds = %j.header
  %j.next = add i64 %j.j, -1
  br label %j.header

check:                                            ; preds = %j.header
  %cmp.ij.not = icmp sgt i64 %i.h, %j.j
  br i1 %cmp.ij.not, label %after, label %swap

swap:                                             ; preds = %check
  store i32 %j.load, i32* %i.ptr, align 4
  store i32 %i.load, i32* %j.ptr, align 4
  %j.after.swap = add i64 %j.j, -1
  %i.after.swap = add i64 %i.h, 1
  br label %i.header

after:                                            ; preds = %check
  %left.size = sub i64 %j.j, %left.cur
  %right.size = sub i64 %right.cur, %i.h
  %cmp.size.not = icmp slt i64 %left.size, %right.size
  br i1 %cmp.size.not, label %left.small, label %right.small

left.small:                                       ; preds = %after
  %cond.left.recurse = icmp sgt i64 %j.j, %left.cur
  br i1 %cond.left.recurse, label %left.recurse, label %left.no.recurse

left.recurse:                                     ; preds = %left.small
  call void @quick_sort(i32* %base, i64 %left.cur, i64 %j.j)
  br label %left.no.recurse

left.no.recurse:                                  ; preds = %left.recurse, %left.small
  br label %outer.cond

right.small:                                      ; preds = %after
  %cond.right.recurse = icmp sgt i64 %right.cur, %i.h
  br i1 %cond.right.recurse, label %right.recurse, label %right.no.recurse

right.recurse:                                    ; preds = %right.small
  call void @quick_sort(i32* %base, i64 %i.h, i64 %right.cur)
  br label %right.no.recurse

right.no.recurse:                                 ; preds = %right.recurse, %right.small
  br label %outer.cond

exit:                                             ; preds = %outer.cond
  ret void
}
