; ModuleID = 'linear_search'
source_filename = "linear_search"

define i32 @linear_search(i32* %arr, i32 %len, i32 %target) {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %cont ]
  %cond = icmp slt i32 %i, %len
  br i1 %cond, label %body, label %exit

body:
  %idx = sext i32 %i to i64
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %idx
  %val = load i32, i32* %ptr, align 4
  %eq = icmp eq i32 %val, %target
  br i1 %eq, label %found, label %cont

found:
  ret i32 %i

cont:
  %i.next = add i32 %i, 1
  br label %loop

exit:
  ret i32 -1
}