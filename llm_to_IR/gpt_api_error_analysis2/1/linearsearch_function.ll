; ModuleID = 'linear_search'
target triple = "x86_64-pc-linux-gnu"

define i32 @linear_search(i32* %arr, i32 %n, i32 %key) {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %inc, %cont ]
  %cmp_end = icmp slt i32 %i, %n
  br i1 %cmp_end, label %body, label %not_found

body:
  %idxext = sext i32 %i to i64
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %idxext
  %val = load i32, i32* %ptr, align 4
  %cmp = icmp eq i32 %val, %key
  br i1 %cmp, label %found, label %cont

found:
  ret i32 %i

cont:
  %inc = add i32 %i, 1
  br label %loop

not_found:
  ret i32 -1
}