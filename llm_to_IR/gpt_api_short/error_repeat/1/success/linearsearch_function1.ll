; ModuleID = 'linear_search'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: linear_search ; Address: 0x1189
; Intent: find index of target in int array, else -1 (confidence=0.98). Evidence: iterates over 4-byte elements, compares to key, returns index or 0xFFFFFFFF
; Preconditions: arr points to at least n 32-bit integers; n >= 0
; Postconditions: returns index of first occurrence equal to target; -1 if not found

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

define dso_local i32 @linear_search(i32* %arr, i32 %n, i32 %target) local_unnamed_addr {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %inc, %cont ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %body, label %end

body:
  %idx.ext = sext i32 %i to i64
  %elt.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx.ext
  %val = load i32, i32* %elt.ptr, align 4
  %eq = icmp eq i32 %val, %target
  br i1 %eq, label %found, label %cont

cont:
  %inc = add nsw i32 %i, 1
  br label %loop

found:
  ret i32 %i

end:
  ret i32 -1
}