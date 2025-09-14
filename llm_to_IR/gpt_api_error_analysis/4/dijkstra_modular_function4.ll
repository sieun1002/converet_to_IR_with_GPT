; ModuleID = 'min_index'
target triple = "x86_64-pc-linux-gnu"

define i32 @min_index(ptr noundef %arr, ptr noundef %flags, i32 noundef %len) local_unnamed_addr {
entry:
  br label %loop.header

loop.header:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.latch ]
  %minVal = phi i32 [ 2147483647, %entry ], [ %minVal.next, %loop.latch ]
  %minIdx = phi i32 [ -1, %entry ], [ %minIdx.next, %loop.latch ]
  %cmp = icmp slt i32 %i, %len
  br i1 %cmp, label %loop.body, label %exit

loop.body:
  %i.ext = sext i32 %i to i64
  %flag.ptr = getelementptr inbounds i32, ptr %flags, i64 %i.ext
  %flag = load i32, ptr %flag.ptr, align 4
  %flag.nz = icmp ne i32 %flag, 0
  br i1 %flag.nz, label %no_update, label %check_val

check_val:
  %arr.ptr = getelementptr inbounds i32, ptr %arr, i64 %i.ext
  %val = load i32, ptr %arr.ptr, align 4
  %is.less = icmp slt i32 %val, %minVal
  br i1 %is.less, label %do_update, label %no_update2

no_update:
  br label %loop.latch

do_update:
  br label %loop.latch

no_update2:
  br label %loop.latch

loop.latch:
  %minVal.next = phi i32 [ %minVal, %no_update ], [ %val, %do_update ], [ %minVal, %no_update2 ]
  %minIdx.next = phi i32 [ %minIdx, %no_update ], [ %i, %do_update ], [ %minIdx, %no_update2 ]
  %i.next = add nsw i32 %i, 1
  br label %loop.header

exit:
  ret i32 %minIdx
}