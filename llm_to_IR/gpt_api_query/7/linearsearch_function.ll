; ModuleID = 'linear_search'
target triple = "x86_64-unknown-linux-gnu"

define dso_local i32 @linear_search(i32* %arr, i32 %len, i32 %target) local_unnamed_addr {
entry:
  br label %loop.cond

loop.cond:                                         ; preds = %loop.inc, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.inc ]
  %cmp = icmp slt i32 %i, %len
  br i1 %cmp, label %loop.body, label %notfound

loop.body:                                         ; preds = %loop.cond
  %idx.ext = sext i32 %i to i64
  %elt.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx.ext
  %elt = load i32, i32* %elt.ptr, align 4
  %eq = icmp eq i32 %elt, %target
  br i1 %eq, label %found, label %loop.inc

loop.inc:                                          ; preds = %loop.body
  %i.next = add nsw i32 %i, 1
  br label %loop.cond

found:                                             ; preds = %loop.body
  ret i32 %i

notfound:                                          ; preds = %loop.cond
  ret i32 -1
}