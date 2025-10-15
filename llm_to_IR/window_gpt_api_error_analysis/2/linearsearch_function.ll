; ModuleID = 'linear_search_module'
source_filename = "linear_search.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

define dso_local i32 @linear_search(i32* noundef %arr, i32 noundef %len, i32 noundef %target) local_unnamed_addr #0 {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %cont ]
  %cond = icmp slt i32 %i, %len
  br i1 %cond, label %body, label %end

body:
  %idxext = sext i32 %i to i64
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %idxext
  %val = load i32, i32* %ptr, align 4
  %eq = icmp eq i32 %val, %target
  br i1 %eq, label %found, label %cont

found:
  ret i32 %i

cont:
  %i.next = add nsw i32 %i, 1
  br label %loop

end:
  ret i32 -1
}

attributes #0 = { nounwind }