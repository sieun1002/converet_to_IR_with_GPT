; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/5/quicksort_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/5/quicksort_function.ll"
target triple = "x86_64-unknown-linux-gnu"

define dso_local void @quick_sort(i32* nocapture %arr, i64 %lo, i64 %hi) local_unnamed_addr {
entry:
  br label %while.head

while.head:                                       ; preds = %outer.cont, %entry
  %lo.ph = phi i64 [ %lo, %entry ], [ %lo.next, %outer.cont ]
  %hi.ph = phi i64 [ %hi, %entry ], [ %hi.next, %outer.cont ]
  %cmp.lohi = icmp sgt i64 %hi.ph, %lo.ph
  br i1 %cmp.lohi, label %partition.init, label %exit

partition.init:                                   ; preds = %while.head
  %diff = sub nsw i64 %hi.ph, %lo.ph
  %half = ashr i64 %diff, 1
  %mid = add nsw i64 %lo.ph, %half
  %pivot.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot = load i32, i32* %pivot.ptr, align 4
  br label %scan.i

scan.i:                                           ; preds = %do.swap, %scan.i.inc, %partition.init
  %i.cur = phi i64 [ %lo.ph, %partition.init ], [ %i.next, %scan.i.inc ], [ %i.after, %do.swap ]
  %j.start = phi i64 [ %hi.ph, %partition.init ], [ %j.start, %scan.i.inc ], [ %j.after, %do.swap ]
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.cur
  %i.val = load i32, i32* %i.ptr, align 4
  %cmp.pivot.gt.i = icmp sgt i32 %pivot, %i.val
  br i1 %cmp.pivot.gt.i, label %scan.i.inc, label %scan.j

scan.i.inc:                                       ; preds = %scan.i
  %i.next = add nsw i64 %i.cur, 1
  br label %scan.i

scan.j:                                           ; preds = %scan.i, %scan.j.dec
  %j.cur = phi i64 [ %j.next, %scan.j.dec ], [ %j.start, %scan.i ]
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.cur
  %j.val = load i32, i32* %j.ptr, align 4
  %cmp.pivot.lt.j = icmp slt i32 %pivot, %j.val
  br i1 %cmp.pivot.lt.j, label %scan.j.dec, label %check

scan.j.dec:                                       ; preds = %scan.j
  %j.next = add nsw i64 %j.cur, -1
  br label %scan.j

check:                                            ; preds = %scan.j
  %cmp.i.le.j.not = icmp sgt i64 %i.cur, %j.cur
  br i1 %cmp.i.le.j.not, label %after.inner, label %do.swap

do.swap:                                          ; preds = %check
  store i32 %j.val, i32* %i.ptr, align 4
  store i32 %i.val, i32* %j.ptr, align 4
  %j.after = add nsw i64 %j.cur, -1
  %i.after = add nsw i64 %i.cur, 1
  br label %scan.i

after.inner:                                      ; preds = %check
  %left.size = sub nsw i64 %j.cur, %lo.ph
  %right.size = sub nsw i64 %hi.ph, %i.cur
  %cmp.left.ge.right.not = icmp slt i64 %left.size, %right.size
  br i1 %cmp.left.ge.right.not, label %left.first, label %right.first

left.first:                                       ; preds = %after.inner
  %condL = icmp sgt i64 %j.cur, %lo.ph
  br i1 %condL, label %call.left, label %outer.cont

call.left:                                        ; preds = %left.first
  call void @quick_sort(i32* %arr, i64 %lo.ph, i64 %j.cur)
  br label %outer.cont

right.first:                                      ; preds = %after.inner
  %condR = icmp sgt i64 %hi.ph, %i.cur
  br i1 %condR, label %call.right, label %outer.cont

call.right:                                       ; preds = %right.first
  call void @quick_sort(i32* %arr, i64 %i.cur, i64 %hi.ph)
  br label %outer.cont

outer.cont:                                       ; preds = %right.first, %call.right, %left.first, %call.left
  %lo.next = phi i64 [ %i.cur, %call.left ], [ %i.cur, %left.first ], [ %lo.ph, %call.right ], [ %lo.ph, %right.first ]
  %hi.next = phi i64 [ %hi.ph, %call.left ], [ %hi.ph, %left.first ], [ %j.cur, %call.right ], [ %j.cur, %right.first ]
  br label %while.head

exit:                                             ; preds = %while.head
  ret void
}
