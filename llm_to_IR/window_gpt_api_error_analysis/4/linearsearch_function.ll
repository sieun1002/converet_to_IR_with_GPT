; ModuleID = 'linear_search_module'
target triple = "x86_64-pc-windows-msvc"

define i32 @linear_search(i32* %arr, i32 %len, i32 %target) {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %inc, %latch ]
  %cmp = icmp slt i32 %i, %len
  br i1 %cmp, label %body, label %exit

body:
  %idx.ext = sext i32 %i to i64
  %p = getelementptr inbounds i32, i32* %arr, i64 %idx.ext
  %val = load i32, i32* %p, align 4
  %eq = icmp eq i32 %val, %target
  br i1 %eq, label %retfound, label %latch

latch:
  %inc = add nsw i32 %i, 1
  br label %loop

retfound:
  ret i32 %i

exit:
  ret i32 -1
}