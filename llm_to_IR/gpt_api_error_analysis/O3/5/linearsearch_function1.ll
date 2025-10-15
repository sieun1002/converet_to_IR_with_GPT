define i32 @linear_search(i32* %arr, i32 %len, i32 %key) {
entry:
  %cmp0 = icmp sle i32 %len, 0
  br i1 %cmp0, label %notfound, label %len_pos

len_pos:
  %bound = sext i32 %len to i64
  br label %loop

loop:
  %i = phi i64 [ 0, %len_pos ], [ %i.next, %advance ]
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %val = load i32, i32* %ptr, align 4
  %eq = icmp eq i32 %val, %key
  br i1 %eq, label %found, label %advance

advance:
  %i.next = add i64 %i, 1
  %done = icmp eq i64 %i.next, %bound
  br i1 %done, label %notfound, label %loop

found:
  %ret = trunc i64 %i to i32
  ret i32 %ret

notfound:
  ret i32 -1
}