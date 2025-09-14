; ModuleID = 'linear_search'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: linear_search  ; Address: 0x1189
; Intent: Linear search for a 32-bit value in an array, return index or -1 (confidence=0.98). Evidence: loop over i32 array comparing to target; returns index or 0xFFFFFFFF.
; Preconditions: %arr points to at least %n 32-bit elements; %n is treated as a signed 32-bit length.
; Postconditions: Returns the first index in [0, %n) where arr[i] == target, else -1.

; Only the needed extern declarations:
; (none)

define dso_local i32 @linear_search(i32* %arr, i32 %n, i32 %target) local_unnamed_addr {
entry:
  br label %loop.cond

loop.cond:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.next ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %loop.body, label %end.notfound

loop.body:
  %idx.ext = sext i32 %i to i64
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %idx.ext
  %val = load i32, i32* %ptr, align 4
  %eq = icmp eq i32 %val, %target
  br i1 %eq, label %found, label %loop.next

loop.next:
  %i.next = add i32 %i, 1
  br label %loop.cond

found:
  ret i32 %i

end.notfound:
  ret i32 -1
}