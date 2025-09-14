; ModuleID = 'linear_search'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: linear_search  ; Address: 0x1189
; Intent: linear search over int32 array returning index or -1 (confidence=0.98). Evidence: element load with 4-byte stride; loop i<n, compare vs key
; Preconditions: arr points to at least n 32-bit elements; n >= 0
; Postconditions: returns index of first occurrence of key in arr[0..n-1], or -1 if not found

define dso_local i32 @linear_search(i32* %arr, i32 %n, i32 %key) local_unnamed_addr {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %cont ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %body, label %notfound

body:
  %idx.ext = sext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx.ext
  %elem = load i32, i32* %elem.ptr, align 4
  %eq = icmp eq i32 %elem, %key
  br i1 %eq, label %found, label %cont

found:
  ret i32 %i

cont:
  %i.next = add nsw i32 %i, 1
  br label %loop

notfound:
  ret i32 -1
}