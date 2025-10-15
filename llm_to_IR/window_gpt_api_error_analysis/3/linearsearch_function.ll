; ModuleID = 'linear_search_module'
target triple = "x86_64-pc-windows-msvc"

define dso_local i32 @linear_search(i32* nocapture readonly %arr, i32 %len, i32 %target) local_unnamed_addr {
entry:
  br label %check

check:
  %i = phi i32 [ 0, %entry ], [ %inc, %cont ]
  %cmp = icmp slt i32 %i, %len
  br i1 %cmp, label %body, label %ret_neg1

body:
  %idxext = sext i32 %i to i64
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %idxext
  %val = load i32, i32* %ptr, align 4
  %eq = icmp eq i32 %val, %target
  br i1 %eq, label %ret_idx, label %cont

cont:
  %inc = add nsw i32 %i, 1
  br label %check

ret_idx:
  ret i32 %i

ret_neg1:
  ret i32 -1
}