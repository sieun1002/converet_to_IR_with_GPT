; ModuleID = 'linear_search'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: linear_search  ; Address: 0x1189
; Intent: Linear search for a 32-bit value in an array, returning index or -1 (confidence=0.98). Evidence: 4-byte element access with scaled index; -1 sentinel on miss
; Preconditions: arr points to at least n 32-bit integers; n >= 0
; Postconditions: returns index of first match in [0, n), or -1 if not found

; Only the needed extern declarations:
; (none)

define dso_local i32 @linear_search(i32* %arr, i32 %n, i32 %target) local_unnamed_addr {
entry:
  br label %cond

cond:                                             ; preds = %entry, %body_end
  %i = phi i32 [ 0, %entry ], [ %inc, %body_end ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %body, label %not_found

body:                                             ; preds = %cond
  %idx.ext = sext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx.ext
  %val = load i32, i32* %elem.ptr
  %eq = icmp eq i32 %target, %val
  br i1 %eq, label %found, label %body_end

body_end:                                         ; preds = %body
  %inc = add nsw i32 %i, 1
  br label %cond

found:                                            ; preds = %body
  ret i32 %i

not_found:                                        ; preds = %cond
  ret i32 -1
}