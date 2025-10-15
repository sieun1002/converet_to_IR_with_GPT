; ModuleID = 'linear_search'
target triple = "x86_64-pc-linux-gnu"

define i32 @linear_search(i32* nocapture readonly %arr, i32 %len, i32 %target) local_unnamed_addr nounwind {
entry:
  br label %loop.header

loop.header:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.latch ]
  %cmp.bound = icmp slt i32 %i, %len
  br i1 %cmp.bound, label %loop.body, label %exit.notfound

loop.body:
  %idx.ext = sext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx.ext
  %elem.val = load i32, i32* %elem.ptr, align 4
  %cmp.eq = icmp eq i32 %elem.val, %target
  br i1 %cmp.eq, label %found, label %loop.latch

found:
  ret i32 %i

loop.latch:
  %i.next = add nsw i32 %i, 1
  br label %loop.header

exit.notfound:
  ret i32 -1
}