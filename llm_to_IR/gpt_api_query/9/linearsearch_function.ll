; ModuleID = 'linear_search.ll'
source_filename = "linear_search"

define i32 @linear_search(i32* %arr, i32 %len, i32 %target) {
entry:
  br label %loop.cond

loop.cond:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.inc ]
  %cmp = icmp slt i32 %i, %len
  br i1 %cmp, label %loop.body, label %exit.notfound

loop.body:
  %idx = sext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx
  %elem = load i32, i32* %elem.ptr, align 4
  %eq = icmp eq i32 %target, %elem
  br i1 %eq, label %found, label %loop.inc

loop.inc:
  %i.next = add nsw i32 %i, 1
  br label %loop.cond

found:
  ret i32 %i

exit.notfound:
  ret i32 -1
}