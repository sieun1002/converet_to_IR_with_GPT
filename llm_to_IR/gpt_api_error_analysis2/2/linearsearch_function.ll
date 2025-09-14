; ModuleID = 'linear_search'

define i32 @linear_search(i32* %arr, i32 %len, i32 %target) {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %notfound ]
  %cmp = icmp slt i32 %i, %len
  br i1 %cmp, label %body, label %exit

body:
  %idx64 = sext i32 %i to i64
  %elem.ptr = getelementptr i32, i32* %arr, i64 %idx64
  %elem = load i32, i32* %elem.ptr, align 4
  %eq = icmp eq i32 %target, %elem
  br i1 %eq, label %found, label %notfound

notfound:
  %i.next = add i32 %i, 1
  br label %loop

found:
  ret i32 %i

exit:
  ret i32 -1
}