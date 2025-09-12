; ModuleID = 'linear_search'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: linear_search ; Address: 0x1189
; Intent: find index of target in int array (confidence=0.98). Evidence: loop over array[i] comparing to key; return i or -1
; Preconditions: arr points to at least len 32-bit integers; len >= 0
; Postconditions: returns index of first match, or -1 if not found

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

define dso_local i32 @linear_search(i32* %arr, i32 %len, i32 %target) local_unnamed_addr {
entry:
  br label %cond

cond:                                             ; preds = %inc, %entry
  %i.cur = phi i32 [ 0, %entry ], [ %i.next, %inc ]
  %cmp = icmp slt i32 %i.cur, %len
  br i1 %cmp, label %body, label %ret_not_found

body:                                             ; preds = %cond
  %i64 = sext i32 %i.cur to i64
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %i64
  %val = load i32, i32* %ptr, align 4
  %eq = icmp eq i32 %val, %target
  br i1 %eq, label %ret_found, label %inc

inc:                                              ; preds = %body
  %i.next = add nsw i32 %i.cur, 1
  br label %cond

ret_found:                                        ; preds = %body
  ret i32 %i.cur

ret_not_found:                                    ; preds = %cond
  ret i32 -1
}