; ModuleID = 'linear_search'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: linear_search ; Address: 0x1189
; Intent: linear search for target in 32-bit int array, return index or -1 (confidence=0.98). Evidence: iterates i, compares *(arr+i) to target, returns i or -1.
; Preconditions: len >= 0; arr points to at least len 32-bit elements.
; Postconditions: returns index i in [0, len) with arr[i] == target, else -1.

; Only the necessary external declarations:

define dso_local i32 @linear_search(i32* nocapture readonly %arr, i32 %len, i32 %target) local_unnamed_addr {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %inc, %loop.next ]
  %cmp = icmp slt i32 %i, %len
  br i1 %cmp, label %loop.body, label %end.notfound

loop.body:
  %idx.ext = sext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx.ext
  %elem = load i32, i32* %elem.ptr, align 4
  %eq = icmp eq i32 %elem, %target
  br i1 %eq, label %found, label %loop.next

loop.next:
  %inc = add nsw i32 %i, 1
  br label %loop

found:
  ret i32 %i

end.notfound:
  ret i32 -1
}