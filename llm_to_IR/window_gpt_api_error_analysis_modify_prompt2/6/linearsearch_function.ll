target triple = "x86_64-pc-windows-msvc"

define i32 @linear_search(i32* %arr, i32 %n, i32 %val) {
entry:
  br label %loop.cond

loop.cond:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.inc ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %loop.body, label %exit.notfound

loop.body:
  %idx64 = sext i32 %i to i64
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %idx64
  %elem = load i32, i32* %ptr
  %eq = icmp eq i32 %elem, %val
  br i1 %eq, label %found, label %loop.inc

found:
  ret i32 %i

loop.inc:
  %i.next = add i32 %i, 1
  br label %loop.cond

exit.notfound:
  ret i32 -1
}