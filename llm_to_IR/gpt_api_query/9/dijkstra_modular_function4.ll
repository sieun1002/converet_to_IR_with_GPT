; ModuleID = 'min_index'
source_filename = "min_index.c"

define i32 @min_index(i32* %arr, i32* %mask, i32 %len) {
entry:
  br label %loop

loop:                                             ; preds = %latch, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %latch ]
  %bestVal = phi i32 [ 2147483647, %entry ], [ %bestVal.next, %latch ]
  %bestIdx = phi i32 [ -1, %entry ], [ %bestIdx.next, %latch ]
  %cmp = icmp slt i32 %i, %len
  br i1 %cmp, label %body, label %exit

body:                                             ; preds = %loop
  %idxext = sext i32 %i to i64
  %mask.ptr = getelementptr inbounds i32, i32* %mask, i64 %idxext
  %maskval = load i32, i32* %mask.ptr, align 4
  %mask_is_zero = icmp eq i32 %maskval, 0
  br i1 %mask_is_zero, label %check, label %latch

check:                                            ; preds = %body
  %arr.ptr = getelementptr inbounds i32, i32* %arr, i64 %idxext
  %arrval = load i32, i32* %arr.ptr, align 4
  %is_less = icmp slt i32 %arrval, %bestVal
  br i1 %is_less, label %update, label %latch

update:                                           ; preds = %check
  br label %latch

latch:                                            ; preds = %update, %check, %body
  %bestVal.next = phi i32 [ %bestVal, %body ], [ %bestVal, %check ], [ %arrval, %update ]
  %bestIdx.next = phi i32 [ %bestIdx, %body ], [ %bestIdx, %check ], [ %i, %update ]
  %i.next = add nsw i32 %i, 1
  br label %loop

exit:                                             ; preds = %loop
  ret i32 %bestIdx
}