; ModuleID = 'min_index.ll'
target triple = "x86_64-pc-linux-gnu"

define dso_local i32 @min_index(i32* nocapture readonly %arr, i32* nocapture readonly %flags, i32 %len) local_unnamed_addr {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %inc ]
  %minval = phi i32 [ 2147483647, %entry ], [ %minval.next, %inc ]
  %minidx = phi i32 [ -1, %entry ], [ %minidx.next, %inc ]
  %cmp.len = icmp sge i32 %i, %len
  br i1 %cmp.len, label %exit, label %checkflag

checkflag:
  %idx.ext = sext i32 %i to i64
  %flag.ptr = getelementptr inbounds i32, i32* %flags, i64 %idx.ext
  %flag.val = load i32, i32* %flag.ptr, align 4
  %flag.nz = icmp ne i32 %flag.val, 0
  br i1 %flag.nz, label %inc, label %checkmin

checkmin:
  %arr.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx.ext
  %arr.val = load i32, i32* %arr.ptr, align 4
  %lt = icmp slt i32 %arr.val, %minval
  br i1 %lt, label %update, label %inc

update:
  br label %inc

inc:
  %minval.next = phi i32 [ %minval, %checkmin ], [ %minval, %checkflag ], [ %arr.val, %update ]
  %minidx.next = phi i32 [ %minidx, %checkmin ], [ %minidx, %checkflag ], [ %i, %update ]
  %i.next = add nsw i32 %i, 1
  br label %loop

exit:
  ret i32 %minidx
}