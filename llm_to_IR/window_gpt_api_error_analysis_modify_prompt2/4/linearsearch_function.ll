target triple = "x86_64-pc-windows-msvc"

define i32 @linear_search(i32* %arr, i32 %len, i32 %target) {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %cont ]
  %cmp = icmp slt i32 %i, %len
  br i1 %cmp, label %body, label %notfound

body:
  %idx = sext i32 %i to i64
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %idx
  %val = load i32, i32* %ptr, align 4
  %eq = icmp eq i32 %val, %target
  br i1 %eq, label %found, label %cont

cont:
  %i.next = add i32 %i, 1
  br label %loop

found:
  ret i32 %i

notfound:
  ret i32 -1
}