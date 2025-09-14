; ModuleID = 'min_index.ll'
source_filename = "min_index.c"

define dso_local i32 @min_index(i32* %values, i32* %flags, i32 %n) local_unnamed_addr {
entry:
  br label %loop

loop:                                             ; preds = %latch, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %latch ]
  %best_idx = phi i32 [ -1, %entry ], [ %best_idx.next, %latch ]
  %best_val = phi i32 [ 2147483647, %entry ], [ %best_val.next, %latch ]
  %exitcond = icmp sge i32 %i, %n
  br i1 %exitcond, label %exit, label %body

body:                                             ; preds = %loop
  %idxprom = sext i32 %i to i64
  %flags.ptr = getelementptr inbounds i32, i32* %flags, i64 %idxprom
  %flag = load i32, i32* %flags.ptr, align 4
  %is_zero = icmp eq i32 %flag, 0
  br i1 %is_zero, label %check_val, label %latch

check_val:                                        ; preds = %body
  %values.ptr = getelementptr inbounds i32, i32* %values, i64 %idxprom
  %val = load i32, i32* %values.ptr, align 4
  %less = icmp slt i32 %val, %best_val
  br i1 %less, label %update, label %latch

update:                                           ; preds = %check_val
  br label %latch

latch:                                            ; preds = %body, %check_val, %update
  %best_val.next = phi i32 [ %best_val, %body ], [ %best_val, %check_val ], [ %val, %update ]
  %best_idx.next = phi i32 [ %best_idx, %body ], [ %best_idx, %check_val ], [ %i, %update ]
  %i.next = add nsw i32 %i, 1
  br label %loop

exit:                                             ; preds = %loop
  ret i32 %best_idx
}