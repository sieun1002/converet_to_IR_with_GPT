define i32 @min_index(i32* %arr, i32* %flag, i32 %n) {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %latch ]
  %minval = phi i32 [ 2147483647, %entry ], [ %minval.next, %latch ]
  %minidx = phi i32 [ -1, %entry ], [ %minidx.next, %latch ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %check_flag, label %exit

check_flag:
  %idx.ext = sext i32 %i to i64
  %flag.ptr = getelementptr inbounds i32, i32* %flag, i64 %idx.ext
  %flag.val = load i32, i32* %flag.ptr, align 4
  %iszero = icmp eq i32 %flag.val, 0
  br i1 %iszero, label %maybe_update, label %latch

maybe_update:
  %arr.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx.ext
  %arr.val = load i32, i32* %arr.ptr, align 4
  %lt = icmp slt i32 %arr.val, %minval
  br i1 %lt, label %do_update, label %latch

do_update:
  br label %latch

latch:
  %minval.next = phi i32 [ %minval, %check_flag ], [ %minval, %maybe_update ], [ %arr.val, %do_update ]
  %minidx.next = phi i32 [ %minidx, %check_flag ], [ %minidx, %maybe_update ], [ %i, %do_update ]
  %i.next = add i32 %i, 1
  br label %loop

exit:
  ret i32 %minidx
}