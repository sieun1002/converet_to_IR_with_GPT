; ModuleID = 'linear_search'
target triple = "x86_64-pc-windows-msvc"

define dso_local i32 @linear_search(i32* %arr, i32 %n, i32 %target) {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %cont ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %body, label %end

body:
  %idx.ext = sext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx.ext
  %elem = load i32, i32* %elem.ptr, align 4
  %eq = icmp eq i32 %target, %elem
  br i1 %eq, label %ret_found, label %cont

cont:
  %i.next = add nsw i32 %i, 1
  br label %loop

ret_found:
  ret i32 %i

end:
  ret i32 -1
}