target triple = "x86_64-pc-windows-msvc"

define i32 @linear_search(i32* %arr, i32 %len, i32 %target) {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %inc, %increment ]
  %cmp = icmp slt i32 %i, %len
  br i1 %cmp, label %body, label %ret_notfound

body:
  %idx64 = sext i32 %i to i64
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %idx64
  %val = load i32, i32* %ptr, align 4
  %eq = icmp eq i32 %val, %target
  br i1 %eq, label %ret_found, label %increment

increment:
  %inc = add nsw i32 %i, 1
  br label %loop

ret_found:
  ret i32 %i

ret_notfound:
  ret i32 -1
}