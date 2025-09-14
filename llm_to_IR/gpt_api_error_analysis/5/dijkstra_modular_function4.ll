; ModuleID = 'min_index'
source_filename = "min_index.c"
target triple = "x86_64-pc-linux-gnu"

define i32 @min_index(i32* nocapture readonly %arr, i32* nocapture readonly %mask, i32 %n) local_unnamed_addr nounwind {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %inc ]
  %min = phi i32 [ 2147483647, %entry ], [ %min.sel, %inc ]
  %best = phi i32 [ -1, %entry ], [ %best.sel, %inc ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %body, label %end

body:
  %idx = sext i32 %i to i64
  %mask.ptr = getelementptr inbounds i32, i32* %mask, i64 %idx
  %mask.val = load i32, i32* %mask.ptr, align 4
  %mask.iszero = icmp eq i32 %mask.val, 0
  br i1 %mask.iszero, label %maybe_update, label %inc

maybe_update:
  %arr.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx
  %arr.val = load i32, i32* %arr.ptr, align 4
  %isless = icmp slt i32 %arr.val, %min
  br i1 %isless, label %do_update, label %inc

do_update:
  br label %inc

inc:
  %i.inc = phi i32 [ %i, %body ], [ %i, %maybe_update ], [ %i, %do_update ]
  %min.sel = phi i32 [ %min, %body ], [ %min, %maybe_update ], [ %arr.val, %do_update ]
  %best.sel = phi i32 [ %best, %body ], [ %best, %maybe_update ], [ %i, %do_update ]
  %i.next = add nsw i32 %i.inc, 1
  br label %loop

end:
  ret i32 %best
}