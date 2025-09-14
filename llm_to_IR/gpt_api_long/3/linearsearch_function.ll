; ModuleID = 'linear_search'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: linear_search  ; Address: 0x1189
; Intent: linear search in int array; return index of key or -1 (confidence=0.98). Evidence: 4-byte stride element access, loop i<n, return -1 on miss
; Preconditions: arr points to at least n 32-bit elements; n >= 0
; Postconditions: returns first index i where arr[i]==key, else -1

define dso_local i32 @linear_search(i32* %arr, i32 %n, i32 %key) local_unnamed_addr {
entry:
  br label %loop

loop:                                             ; preds = %entry, %cont
  %i = phi i32 [ 0, %entry ], [ %i.next, %cont ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %body, label %notfound

body:                                             ; preds = %loop
  %idx.ext = sext i32 %i to i64
  %elt.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx.ext
  %elt = load i32, i32* %elt.ptr, align 4
  %eq = icmp eq i32 %key, %elt
  br i1 %eq, label %found, label %cont

cont:                                             ; preds = %body
  %i.next = add i32 %i, 1
  br label %loop

found:                                            ; preds = %body
  ret i32 %i

notfound:                                         ; preds = %loop
  ret i32 -1
}