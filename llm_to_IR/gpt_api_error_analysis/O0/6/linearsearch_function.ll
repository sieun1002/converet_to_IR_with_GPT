target triple = "x86_64-pc-linux-gnu"

define dso_local i32 @linear_search(i32* %arr, i32 %len, i32 %key) {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %continue ]
  %cmp = icmp slt i32 %i, %len
  br i1 %cmp, label %in, label %notfound

in:
  %idxprom = sext i32 %i to i64
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %idxprom
  %val = load i32, i32* %ptr, align 4
  %eq = icmp eq i32 %val, %key
  br i1 %eq, label %found, label %continue

found:
  ret i32 %i

continue:
  %i.next = add nsw i32 %i, 1
  br label %loop

notfound:
  ret i32 -1
}