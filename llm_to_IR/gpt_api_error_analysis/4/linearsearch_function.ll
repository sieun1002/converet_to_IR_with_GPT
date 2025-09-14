; ModuleID = 'linear_search'
target triple = "x86_64-pc-linux-gnu"

define dso_local i32 @linear_search(i32* nocapture readonly %arr, i32 %len, i32 %key) {
entry:
  br label %loop.header

loop.header:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.latch ]
  %cmp = icmp slt i32 %i, %len
  br i1 %cmp, label %loop.body, label %notfound

loop.body:
  %idx.ext = sext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx.ext
  %elem = load i32, i32* %elem.ptr, align 4
  %eq = icmp eq i32 %key, %elem
  br i1 %eq, label %found, label %loop.latch

loop.latch:
  %i.next = add nsw i32 %i, 1
  br label %loop.header

found:
  ret i32 %i

notfound:
  ret i32 -1
}