; ModuleID = 'linear_search'
source_filename = "linear_search.c"
target triple = "x86_64-pc-linux-gnu"

define dso_local i32 @linear_search(i32* noundef %arr, i32 noundef %len, i32 noundef %target) {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %inc ]
  %cmp = icmp slt i32 %i, %len
  br i1 %cmp, label %body, label %notfound

body:
  %idx.ext = sext i32 %i to i64
  %elt.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx.ext
  %elt = load i32, i32* %elt.ptr, align 4
  %eq = icmp eq i32 %elt, %target
  br i1 %eq, label %found, label %inc

inc:
  %i.next = add nsw i32 %i, 1
  br label %loop

found:
  ret i32 %i

notfound:
  ret i32 -1
}