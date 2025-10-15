; ModuleID = 'linear_search'
source_filename = "linear_search.ll"
target triple = "x86_64-pc-windows-msvc"

define dso_local i32 @linear_search(i32* nocapture readonly %arr, i32 %len, i32 %val) {
entry:
  br label %cond

cond:
  %i = phi i32 [ 0, %entry ], [ %inc, %body.end ]
  %cmp = icmp slt i32 %i, %len
  br i1 %cmp, label %body, label %notfound

body:
  %idx.ext = sext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx.ext
  %elem = load i32, i32* %elem.ptr, align 4
  %eq = icmp eq i32 %elem, %val
  br i1 %eq, label %found, label %body.end

body.end:
  %inc = add nsw i32 %i, 1
  br label %cond

found:
  ret i32 %i

notfound:
  ret i32 -1
}