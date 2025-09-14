; ModuleID = 'linear_search'
source_filename = "linear_search"

define dso_local i32 @linear_search(i32* nocapture readonly %arr, i32 %n, i32 %target) local_unnamed_addr {
entry:
  br label %loop.cond

loop.cond:
  %i = phi i32 [ 0, %entry ], [ %inc, %inc.block ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %loop.body, label %exit.notfound

loop.body:
  %i64 = sext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %i64
  %val = load i32, i32* %elem.ptr, align 4
  %eq = icmp eq i32 %val, %target
  br i1 %eq, label %found, label %inc.block

inc.block:
  %inc = add nsw i32 %i, 1
  br label %loop.cond

found:
  ret i32 %i

exit.notfound:
  ret i32 -1
}