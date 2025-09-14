; ModuleID = 'linear_search'
source_filename = "linear_search"
target triple = "x86_64-unknown-linux-gnu"

define i32 @linear_search(i32* %arr, i32 %len, i32 %target) {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %inc ]
  %cmp = icmp slt i32 %i, %len
  br i1 %cmp, label %body, label %ret_not_found

body:
  %idx.ext = sext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx.ext
  %elem = load i32, i32* %elem.ptr, align 4
  %eq = icmp eq i32 %elem, %target
  br i1 %eq, label %ret_found, label %inc

inc:
  %i.next = add nsw i32 %i, 1
  br label %loop

ret_found:
  ret i32 %i

ret_not_found:
  ret i32 -1
}