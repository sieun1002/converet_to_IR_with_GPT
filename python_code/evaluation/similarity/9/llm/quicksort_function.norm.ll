; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/9/quicksort_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/9/quicksort_function.ll"
target triple = "x86_64-unknown-linux-gnu"

define void @quick_sort(i32* nocapture %arr, i64 %lo, i64 %hi) {
entry:
  br label %outer.loop

outer.loop:                                       ; preds = %right.cont, %left.cont, %entry
  %lo.cur = phi i64 [ %lo, %entry ], [ %left.scan, %left.cont ], [ %lo.cur, %right.cont ]
  %hi.cur = phi i64 [ %hi, %entry ], [ %hi.cur, %left.cont ], [ %right.scan, %right.cont ]
  %cmp.outer = icmp sgt i64 %hi.cur, %lo.cur
  br i1 %cmp.outer, label %partition.init, label %ret

partition.init:                                   ; preds = %outer.loop
  %diff = sub i64 %hi.cur, %lo.cur
  %half = sdiv i64 %diff, 2
  %mid = add i64 %lo.cur, %half
  %pivot.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot = load i32, i32* %pivot.ptr, align 4
  br label %scan.loop

scan.loop:                                        ; preds = %doSwap, %partition.init
  %left.cur2 = phi i64 [ %lo.cur, %partition.init ], [ %left.next, %doSwap ]
  %right.cur2 = phi i64 [ %hi.cur, %partition.init ], [ %right.next, %doSwap ]
  br label %incLeft

incLeft:                                          ; preds = %incLeft.inc, %scan.loop
  %left.scan = phi i64 [ %left.cur2, %scan.loop ], [ %left.inc, %incLeft.inc ]
  %pl.ptr = getelementptr inbounds i32, i32* %arr, i64 %left.scan
  %pl = load i32, i32* %pl.ptr, align 4
  %cmpL = icmp slt i32 %pl, %pivot
  br i1 %cmpL, label %incLeft.inc, label %decRight

incLeft.inc:                                      ; preds = %incLeft
  %left.inc = add i64 %left.scan, 1
  br label %incLeft

decRight:                                         ; preds = %incLeft, %decRight.dec
  %right.scan = phi i64 [ %right.dec, %decRight.dec ], [ %right.cur2, %incLeft ]
  %pr.ptr = getelementptr inbounds i32, i32* %arr, i64 %right.scan
  %pr = load i32, i32* %pr.ptr, align 4
  %cmpR = icmp sgt i32 %pr, %pivot
  br i1 %cmpR, label %decRight.dec, label %after.step

decRight.dec:                                     ; preds = %decRight
  %right.dec = add i64 %right.scan, -1
  br label %decRight

after.step:                                       ; preds = %decRight
  %cmpLR.not = icmp sgt i64 %left.scan, %right.scan
  br i1 %cmpLR.not, label %partition.done, label %doSwap

doSwap:                                           ; preds = %after.step
  store i32 %pr, i32* %pl.ptr, align 4
  store i32 %pl, i32* %pr.ptr, align 4
  %left.next = add i64 %left.scan, 1
  %right.next = add i64 %right.scan, -1
  br label %scan.loop

partition.done:                                   ; preds = %after.step
  %len.left = sub i64 %right.scan, %lo.cur
  %len.right = sub i64 %hi.cur, %left.scan
  %cmp.len.not = icmp slt i64 %len.left, %len.right
  br i1 %cmp.len.not, label %left.first, label %right.first

left.first:                                       ; preds = %partition.done
  %need.left = icmp sgt i64 %right.scan, %lo.cur
  br i1 %need.left, label %left.call, label %left.cont

left.call:                                        ; preds = %left.first
  call void @quick_sort(i32* %arr, i64 %lo.cur, i64 %right.scan)
  br label %left.cont

left.cont:                                        ; preds = %left.call, %left.first
  br label %outer.loop

right.first:                                      ; preds = %partition.done
  %need.right = icmp sgt i64 %hi.cur, %left.scan
  br i1 %need.right, label %right.call, label %right.cont

right.call:                                       ; preds = %right.first
  call void @quick_sort(i32* %arr, i64 %left.scan, i64 %hi.cur)
  br label %right.cont

right.cont:                                       ; preds = %right.call, %right.first
  br label %outer.loop

ret:                                              ; preds = %outer.loop
  ret void
}
