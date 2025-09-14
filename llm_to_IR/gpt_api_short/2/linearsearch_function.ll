; ModuleID = 'linear_search'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: linear_search ; Address: 0x1189
; Intent: Find index of key in int32 array via linear scan (confidence=1.00). Evidence: 4-byte stride with i*4 addressing; compare element to key and return index or -1.
; Preconditions: arr points to at least n int32 elements when n > 0.
; Postconditions: Returns index in [0, n) where arr[index] == key, else -1.

define dso_local i32 @linear_search(i32* nocapture readonly %arr, i32 %n, i32 %key) local_unnamed_addr {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %cont ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %body, label %notfound

body:
  %idx.ext = sext i32 %i to i64
  %gep = getelementptr inbounds i32, i32* %arr, i64 %idx.ext
  %val = load i32, i32* %gep, align 4
  %eq = icmp eq i32 %val, %key
  br i1 %eq, label %found, label %cont

found:
  ret i32 %i

cont:
  %i.next = add nsw i32 %i, 1
  br label %loop

notfound:
  ret i32 -1
}