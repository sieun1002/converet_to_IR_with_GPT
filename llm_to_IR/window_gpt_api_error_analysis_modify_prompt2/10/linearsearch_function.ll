target triple = "x86_64-pc-windows-msvc"

define i32 @linear_search(i32* %arr, i32 %n, i32 %key) {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %cont ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %body, label %end

body:
  %idx.ext = sext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx.ext
  %val = load i32, i32* %elem.ptr, align 4
  %eq = icmp eq i32 %key, %val
  br i1 %eq, label %retidx, label %cont

retidx:
  ret i32 %i

cont:
  %i.next = add nsw i32 %i, 1
  br label %loop

end:
  ret i32 -1
}