; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/10/quicksort_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/10/quicksort_function.ll"
target triple = "x86_64-pc-linux-gnu"

define void @quick_sort(i32* noundef %arr, i64 noundef %low, i64 noundef %high) local_unnamed_addr {
entry:
  br label %loop.header

loop.header:                                      ; preds = %back.right, %back.left, %entry
  %low.hdr = phi i64 [ %low, %entry ], [ %i.cur, %back.left ], [ %low.hdr, %back.right ]
  %high.hdr = phi i64 [ %high, %entry ], [ %high.hdr, %back.left ], [ %j.cur, %back.right ]
  %cmp0 = icmp sgt i64 %high.hdr, %low.hdr
  br i1 %cmp0, label %part.init, label %exit

part.init:                                        ; preds = %loop.header
  %diff = sub i64 %high.hdr, %low.hdr
  %shifted = ashr i64 %diff, 1
  %mid = add i64 %low.hdr, %shifted
  %pivot.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot = load i32, i32* %pivot.ptr, align 4
  br label %part.loop.header

part.loop.header:                                 ; preds = %swap.do, %part.init
  %i.loop = phi i64 [ %low.hdr, %part.init ], [ %i.next2, %swap.do ]
  %j.loop = phi i64 [ %high.hdr, %part.init ], [ %j.next2, %swap.do ]
  br label %left.scan

left.scan:                                        ; preds = %left.cont, %part.loop.header
  %i.cur = phi i64 [ %i.loop, %part.loop.header ], [ %i.inc, %left.cont ]
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.cur
  %i.val = load i32, i32* %i.ptr, align 4
  %cmpL = icmp sgt i32 %pivot, %i.val
  br i1 %cmpL, label %left.cont, label %right.scan

left.cont:                                        ; preds = %left.scan
  %i.inc = add i64 %i.cur, 1
  br label %left.scan

right.scan:                                       ; preds = %left.scan, %right.cont
  %j.cur = phi i64 [ %j.dec, %right.cont ], [ %j.loop, %left.scan ]
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.cur
  %j.val = load i32, i32* %j.ptr, align 4
  %cmpR = icmp slt i32 %pivot, %j.val
  br i1 %cmpR, label %right.cont, label %after.scans

right.cont:                                       ; preds = %right.scan
  %j.dec = add i64 %j.cur, -1
  br label %right.scan

after.scans:                                      ; preds = %right.scan
  %cmpIJ.not = icmp sgt i64 %i.cur, %j.cur
  br i1 %cmpIJ.not, label %part.done, label %swap.do

swap.do:                                          ; preds = %after.scans
  store i32 %j.val, i32* %i.ptr, align 4
  store i32 %i.val, i32* %j.ptr, align 4
  %i.next2 = add i64 %i.cur, 1
  %j.next2 = add i64 %j.cur, -1
  br label %part.loop.header

part.done:                                        ; preds = %after.scans
  %leftLen = sub i64 %j.cur, %low.hdr
  %rightLen = sub i64 %high.hdr, %i.cur
  %cmpSizes.not = icmp slt i64 %leftLen, %rightLen
  br i1 %cmpSizes.not, label %branch.leftFirst, label %branch.rightFirst

branch.leftFirst:                                 ; preds = %part.done
  %condL = icmp sgt i64 %j.cur, %low.hdr
  br i1 %condL, label %call.left, label %back.left

call.left:                                        ; preds = %branch.leftFirst
  call void @quick_sort(i32* noundef %arr, i64 noundef %low.hdr, i64 noundef %j.cur)
  br label %back.left

back.left:                                        ; preds = %branch.leftFirst, %call.left
  br label %loop.header

branch.rightFirst:                                ; preds = %part.done
  %condR = icmp sgt i64 %high.hdr, %i.cur
  br i1 %condR, label %call.right, label %back.right

call.right:                                       ; preds = %branch.rightFirst
  call void @quick_sort(i32* noundef %arr, i64 noundef %i.cur, i64 noundef %high.hdr)
  br label %back.right

back.right:                                       ; preds = %branch.rightFirst, %call.right
  br label %loop.header

exit:                                             ; preds = %loop.header
  ret void
}
