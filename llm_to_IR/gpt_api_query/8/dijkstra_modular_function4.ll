; ModuleID = 'min_index'
source_filename = "min_index.c"
target triple = "x86_64-pc-linux-gnu"

define dso_local i32 @min_index(i32* nocapture readonly %arr, i32* nocapture readonly %mask, i32 %len) local_unnamed_addr {
entry:
  %exit_now = icmp sge i32 0, %len
  br i1 %exit_now, label %ret, label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %inc ]
  %minVal = phi i32 [ 2147483647, %entry ], [ %minVal.next, %inc ]
  %minIdx = phi i32 [ -1, %entry ], [ %minIdx.next, %inc ]
  %idx.ext = sext i32 %i to i64
  %mask.ptr = getelementptr inbounds i32, i32* %mask, i64 %idx.ext
  %mask.val = load i32, i32* %mask.ptr, align 4
  %mask.is.zero = icmp eq i32 %mask.val, 0
  br i1 %mask.is.zero, label %checkMin, label %inc

checkMin:
  %arr.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx.ext
  %arr.val = load i32, i32* %arr.ptr, align 4
  %is.less = icmp slt i32 %arr.val, %minVal
  br i1 %is.less, label %update, label %inc

update:
  br label %inc

inc:
  %minVal.next = phi i32 [ %minVal, %loop ], [ %minVal, %checkMin ], [ %arr.val, %update ]
  %minIdx.next = phi i32 [ %minIdx, %loop ], [ %minIdx, %checkMin ], [ %i, %update ]
  %i.next = add i32 %i, 1
  %cond.exit = icmp sge i32 %i.next, %len
  br i1 %cond.exit, label %ret, label %loop

ret:
  %result = phi i32 [ -1, %entry ], [ %minIdx.next, %inc ]
  ret i32 %result
}