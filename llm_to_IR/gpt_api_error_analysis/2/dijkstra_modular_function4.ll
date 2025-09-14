target triple = "x86_64-unknown-linux-gnu"

define i32 @min_index(i32* nocapture readonly %arr1, i32* nocapture readonly %arr2, i32 %len) {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %latch ]
  %min = phi i32 [ 2147483647, %entry ], [ %min.sel, %latch ]
  %idx = phi i32 [ -1, %entry ], [ %idx.sel, %latch ]
  %cmp = icmp slt i32 %i, %len
  br i1 %cmp, label %body, label %exit

body:
  %i64 = sext i32 %i to i64
  %mask.ptr = getelementptr inbounds i32, i32* %arr2, i64 %i64
  %mask = load i32, i32* %mask.ptr, align 4
  %ismaskzero = icmp eq i32 %mask, 0
  br i1 %ismaskzero, label %checkless, label %no_update

checkless:
  %i64b = sext i32 %i to i64
  %val.ptr = getelementptr inbounds i32, i32* %arr1, i64 %i64b
  %val = load i32, i32* %val.ptr, align 4
  %isless = icmp slt i32 %val, %min
  br i1 %isless, label %do_update, label %no_update

do_update:
  br label %latch

no_update:
  br label %latch

latch:
  %min.sel = phi i32 [ %val, %do_update ], [ %min, %no_update ]
  %idx.sel = phi i32 [ %i, %do_update ], [ %idx, %no_update ]
  %i.next = add nsw i32 %i, 1
  br label %loop

exit:
  ret i32 %idx
}