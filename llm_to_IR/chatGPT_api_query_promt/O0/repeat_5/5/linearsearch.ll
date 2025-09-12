; ModuleID = 'linear_search'
source_filename = "linear_search.ll"

define dso_local i32 @linear_search(i32* noundef %arr, i32 noundef %n, i32 noundef %target) local_unnamed_addr {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %inc, %cont ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %body, label %exit

body:
  %idxext = sext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %idxext
  %val = load i32, i32* %elem.ptr, align 4
  %eq = icmp eq i32 %val, %target
  br i1 %eq, label %found, label %cont

found:
  ret i32 %i

cont:
  %inc = add nsw i32 %i, 1
  br label %loop

exit:
  ret i32 -1
}