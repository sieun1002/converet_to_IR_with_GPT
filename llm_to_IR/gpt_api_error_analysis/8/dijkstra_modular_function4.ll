target triple = "x86_64-pc-linux-gnu"

define i32 @min_index(i32* %arr, i32* %flags, i32 %n) {
entry:
  br label %loop.header

loop.header:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.inc ]
  %bestIdx = phi i32 [ -1, %entry ], [ %bestIdx.inc, %loop.inc ]
  %bestVal = phi i32 [ 2147483647, %entry ], [ %bestVal.inc, %loop.inc ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %loop.body, label %exit

loop.body:
  %i64 = sext i32 %i to i64
  %flag.ptr = getelementptr inbounds i32, i32* %flags, i64 %i64
  %flag.val = load i32, i32* %flag.ptr, align 4
  %flag.zero = icmp eq i32 %flag.val, 0
  br i1 %flag.zero, label %checkMin, label %loop.inc

checkMin:
  %arr.ptr = getelementptr inbounds i32, i32* %arr, i64 %i64
  %arr.val = load i32, i32* %arr.ptr, align 4
  %lt = icmp slt i32 %arr.val, %bestVal
  br i1 %lt, label %update, label %loop.inc

update:
  br label %loop.inc

loop.inc:
  %bestVal.inc = phi i32 [ %bestVal, %loop.body ], [ %bestVal, %checkMin ], [ %arr.val, %update ]
  %bestIdx.inc = phi i32 [ %bestIdx, %loop.body ], [ %bestIdx, %checkMin ], [ %i, %update ]
  %i.next = add nsw i32 %i, 1
  br label %loop.header

exit:
  ret i32 %bestIdx
}