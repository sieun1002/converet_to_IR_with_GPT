; ModuleID = 'linear_search'
source_filename = "linear_search"

define dso_local i32 @linear_search(i32* nocapture readonly %arr, i32 %n, i32 %target) {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.inc ]
  %cond = icmp slt i32 %i, %n
  br i1 %cond, label %check, label %ret.notfound

check:
  %idxext = sext i32 %i to i64
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %idxext
  %val = load i32, i32* %ptr
  %eq = icmp eq i32 %val, %target
  br i1 %eq, label %ret.found, label %loop.inc

loop.inc:
  %i.next = add i32 %i, 1
  br label %loop

ret.found:
  ret i32 %i

ret.notfound:
  ret i32 -1
}