; ModuleID = 'linear_search'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: linear_search ; Address: 0x1189
; Intent: Find index of target in int array via linear scan (confidence=0.95). Evidence: 4-byte element access; returns index or -1
; Preconditions: arr points to at least n 32-bit integers; n may be negative
; Postconditions: Returns first index i where arr[i] == target, else -1

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

define dso_local i32 @linear_search(i32* nocapture readonly %arr, i32 %n, i32 %target) local_unnamed_addr {
entry:
  br label %loop

loop:                                             ; preds = %inc, %entry
  %i = phi i32 [ 0, %entry ], [ %next, %inc ]
  %cond = icmp slt i32 %i, %n
  br i1 %cond, label %body, label %end

body:                                             ; preds = %loop
  %idxprom = sext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %idxprom
  %val = load i32, i32* %elem.ptr, align 4
  %eq = icmp eq i32 %val, %target
  br i1 %eq, label %found, label %inc

found:                                            ; preds = %body
  ret i32 %i

inc:                                              ; preds = %body
  %next = add nsw i32 %i, 1
  br label %loop

end:                                              ; preds = %loop
  ret i32 -1
}