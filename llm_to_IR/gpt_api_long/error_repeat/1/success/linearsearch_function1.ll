; ModuleID = 'linear_search'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: linear_search  ; Address: 0x1189
; Intent: linear search for value in int32 array, returning index or -1 (confidence=0.98). Evidence: stride-4 indexing over i32; returns 0xFFFFFFFF when not found
; Preconditions: %a points to at least %n contiguous 32-bit integers if %n > 0
; Postconditions: Returns the first index i in [0, %n) with a[i] == %target; else -1

; Only the needed extern declarations:
; (no externs)

define dso_local i32 @linear_search(i32* %a, i32 %n, i32 %target) local_unnamed_addr {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %cont ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %body, label %exit

body:
  %idx64 = sext i32 %i to i64
  %gep = getelementptr inbounds i32, i32* %a, i64 %idx64
  %val = load i32, i32* %gep, align 4
  %eq = icmp eq i32 %val, %target
  br i1 %eq, label %found, label %cont

found:
  ret i32 %i

cont:
  %i.next = add nsw i32 %i, 1
  br label %loop

exit:
  ret i32 -1
}