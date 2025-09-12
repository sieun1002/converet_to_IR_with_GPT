; ModuleID = 'linear_search'
source_filename = "linear_search"
target triple = "x86_64-pc-linux-gnu"

define dso_local i32 @linear_search(i32* nocapture readonly %arr, i32 %len, i32 %target) local_unnamed_addr {
entry:
  br label %check

check:
  %i = phi i32 [ 0, %entry ], [ %inc, %next ]
  %cond = icmp slt i32 %i, %len
  br i1 %cond, label %body, label %retneg

body:
  %idxprom = sext i32 %i to i64
  %eltptr = getelementptr inbounds i32, i32* %arr, i64 %idxprom
  %val = load i32, i32* %eltptr, align 4
  %eq = icmp eq i32 %val, %target
  br i1 %eq, label %found, label %next

next:
  %inc = add nsw i32 %i, 1
  br label %check

found:
  ret i32 %i

retneg:
  ret i32 -1
}