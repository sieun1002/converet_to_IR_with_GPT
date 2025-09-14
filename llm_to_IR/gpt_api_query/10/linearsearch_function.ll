; ModuleID = 'recovered'
source_filename = "recovered"
target triple = "x86_64-pc-linux-gnu"

define dso_local i32 @linear_search(i32* %arr, i32 %len, i32 %target) {
entry:
  br label %loop.header

loop.header:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.latch ]
  %cond = icmp slt i32 %i, %len
  br i1 %cond, label %loop.body, label %notfound

loop.body:
  %idx.ext = sext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx.ext
  %elem = load i32, i32* %elem.ptr, align 4
  %match = icmp eq i32 %elem, %target
  br i1 %match, label %found, label %loop.latch

loop.latch:
  %i.next = add nsw i32 %i, 1
  br label %loop.header

found:
  ret i32 %i

notfound:
  ret i32 -1
}